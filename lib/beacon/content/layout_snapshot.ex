defmodule Beacon.Content.LayoutSnapshot do
  @moduledoc """
  Layout snapshots

  > #### Do not create or edit layout snapshots manually {: .warning}
  >
  > Use the public functions in `Beacon.Content` instead.
  > The functions in that module guarantee that all dependencies
  > are created correctly and all processes are updated.
  > Manipulating data manually will most likely result
  > in inconsistent behavior and crashes.

  """

  use Ecto.Schema

  @timestamps_opts type: :utc_datetime_usec

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          site: Beacon.Types.Site.t(),
          schema_version: pos_integer(),
          layout_id: Ecto.UUID.t(),
          layout: Beacon.Content.Layout.t(),
          event_id: Ecto.UUID.t(),
          event: Beacon.Content.LayoutEvent.t() | nil,
          inserted_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "beacon_layout_snapshots" do
    field :site, Beacon.Types.Site
    field :schema_version, :integer
    field :layout_id, Ecto.UUID
    field :layout, Beacon.Types.Binary
    belongs_to :event, Beacon.Content.LayoutEvent
    timestamps updated_at: false
  end
end
