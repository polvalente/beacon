defmodule Beacon.Admin.MediaLibrary.Backend.Repo do
  import Ecto.Changeset

  alias Beacon.Admin.MediaLibrary.Asset
  alias Beacon.Admin.MediaLibrary.UploadMetadata

  @backend_key "repo"

  def send_to_cdn(metadata) do
    key = key_for(metadata)
    attrs = %{file_body: metadata.output}

    resource =
      metadata.resource
      |> cast(attrs, [:file_body])
      |> validate_required([:file_body])
      |> Asset.keys_changeset(backend_key(), key)

    %{metadata | resource: resource}
  end

  def key_for(metadata) do
    UploadMetadata.key_for(metadata)
  end

  def url_for(asset, _), do: url_for(asset)

  def url_for(asset) do
    Beacon.Router.beacon_asset_path(beacon_attrs(asset), asset.file_name)
  end

  defp beacon_attrs(asset) do
    %Beacon.BeaconAttrs{site: asset.site, prefix: asset.site}
  end

  def backend_key, do: @backend_key
end
