defmodule Beacon.Admin.MediaLibrary.Backend.S3 do
  alias Beacon.Admin.MediaLibrary.Asset
  alias Beacon.Admin.MediaLibrary.UploadMetadata

  @backend_key "s3"
  @s3_buffer_size 5 * 1024 * 1024

  def send_to_cdn(metadata, config \\ []) do
    key = key_for(metadata)

    chunker = fn bin, acc ->
      acc_size = IO.iodata_length(acc)

      if IO.iodata_length(bin) + acc_size >= @s3_buffer_size do
        size = @s3_buffer_size - acc_size
        <<chunk::binary-size(size), rest::binary>> = bin
        {:cont, IO.iodata_to_binary([acc, chunk]), [rest]}
      else
        {:cont, [acc, bin]}
      end
    end

    final = fn
      [] -> {:cont, []}
      acc -> {:cont, IO.iodata_to_binary(acc), []}
    end

    StringIO.open(metadata.output, [], fn pid ->
      IO.binstream(pid, :line)
      |> Stream.chunk_while([], chunker, final)
      |> ExAws.S3.upload(bucket(), key)
      |> ExAws.request!(config)
    end)

    change = Asset.keys_changeset(metadata.resource, backend_key(), key)
    %{metadata | resource: change}
  end

  def key_for(metadata) do
    UploadMetadata.key_for(metadata)
  end

  def bucket do
    case ExAws.Config.new(:s3) do
      %{bucket: bucket} -> bucket
      _ -> raise ArgumentError, message: "Missing :ex_aws, :s3, bucket: \"...\" configuration"
    end
  end

  def list do
    ExAws.S3.list_objects(bucket()) |> ExAws.request!()
  end

  def url_for(asset, config \\ []) do
    key = Map.fetch!(asset.keys, backend_key())
    Path.join(host(config), key)
  end

  defp host([]) do
    host(ExAws.Config.new(:s3))
  end

  defp host(%{bucket: bucket, host: host} = config) do
    scheme = Map.get(config, :scheme, "https://")
    "#{scheme}#{bucket}.#{host}"
  end

  defp host(_) do
    raise(
      ArgumentError,
      message: "Missing :ex_aws, :s3, bucket: \"...\" or host: \" ...\" configuration"
    )
  end

  def backend_key, do: @backend_key
end
