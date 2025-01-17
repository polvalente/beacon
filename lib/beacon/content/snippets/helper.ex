defmodule Beacon.Content.Snippets.Helper do
  @moduledoc """
  Snippet Helpers

  > #### Do not create or edit snippet helpers manually {: .warning}
  >
  > Use the public functions in `Beacon.Content` instead.
  > The functions in that module guarantee that all dependencies
  > are created correctly and all processes are updated.
  > Manipulating data manually will most likely result
  > in inconsistent behavior and crashes.
  """

  use Ecto.Schema

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "beacon_snippet_helpers" do
    field :site, Beacon.Types.Site
    field :name, :string
    field :body, :string

    timestamps()
  end
end
