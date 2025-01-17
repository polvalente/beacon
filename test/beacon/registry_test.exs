defmodule Beacon.RegistryTest do
  use ExUnit.Case, async: true

  alias Beacon.Registry

  test "running_sites" do
    running_sites = Registry.running_sites()
    assert Enum.sort(running_sites) == [:data_source_test, :default_meta_tags_test, :lifecycle_test, :lifecycle_test_fail, :my_site, :s3_site]
  end

  describe "config!" do
    test "return site config for existing sites" do
      assert %Beacon.Config{
               css_compiler: Beacon.TailwindCompiler,
               data_source: Beacon.BeaconTest.BeaconDataSource,
               authorization_source: Beacon.BeaconTest.BeaconAuthorizationSource,
               live_socket_path: "/custom_live",
               safe_code_check: false,
               site: :my_site,
               tailwind_config: tailwind_config
             } = Registry.config!(:my_site)

      assert tailwind_config =~ "tailwind.config.js.eex"
    end

    test "raise when not found" do
      assert_raise RuntimeError, ~r/Site :invalid was not found/, fn ->
        Registry.config!(:invalid)
      end
    end
  end
end
