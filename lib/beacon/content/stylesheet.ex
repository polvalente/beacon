defmodule Beacon.Content.Stylesheet do
  @moduledoc """
  Stylesheets

  > #### Do not create or edit page snapshots manually {: .warning}
  >
  > Use the public functions in `Beacon.Content` instead.
  > The functions in that module guarantee that all dependencies
  > are created correctly and all processes are updated.
  > Manipulating data manually will most likely result
  > in inconsistent behavior and crashes.

  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "beacon_stylesheets" do
    field :content, :string
    field :name, :string
    field :site, Beacon.Types.Site

    timestamps()
  end

  @doc false
  def changeset(stylesheet, attrs) do
    stylesheet
    |> cast(attrs, [:name, :content, :site])
    |> validate_required([:name, :content, :site])
  end
end
