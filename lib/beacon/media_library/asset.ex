defmodule Beacon.MediaLibrary.Asset do
  @moduledoc false

  use Ecto.Schema
  @derive BeaconWeb.Cache.Stale

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "beacon_assets" do
    field :file_body, :binary
    field :file_name, :string
    field :media_type, :string
    field :site, Beacon.Types.Site
    field :deleted_at, :utc_datetime

    timestamps()
  end
end
