defmodule SmartCity.TestDataGeneratorTest do
  use ExUnit.Case

  alias SmartCity.TestDataGenerator, as: TDG

  test "create_dataset/1 creates a valid dataset" do
    assert match?(%SmartCity.Dataset{}, TDG.create_dataset(%{}))
  end

  test "create_dataset/1 creates a valid dataset with an overridden organization" do
    org_id = "fake_org_id"
    test_dataset = TDG.create_dataset(%{organization_id: org_id})
    assert test_dataset.organization_id == org_id
    assert match?(%SmartCity.Dataset{}, TDG.create_dataset(%{}))
  end

  test "create_dataset/1 makes a valid system name :|" do
    dataset = TDG.create_dataset(%{})

    assert dataset.technical.systemName =~
             "__#{dataset.technical.dataName}"
  end

  test "create_dataset/1 makes a valid system name :| with overrides" do
    data_name = "my_data"

    dataset = TDG.create_dataset(%{technical: %{dataName: data_name}})
    assert dataset.technical.systemName =~ "__my_data"
  end

  test "creates datasets with valid ISO8601 DateTimes for business.modifiedDate" do
    dataset = TDG.create_dataset(%{})

    modified_date = DateTime.from_iso8601(dataset.business.modifiedDate)
    assert elem(modified_date, 0) == :ok
  end

  test "create_organization/1 creates a valid organization" do
    assert match?(%SmartCity.Organization{}, TDG.create_organization(%{}))
  end

  test "create_data/1 creates valid data" do
    assert match?(%SmartCity.Data{}, TDG.create_data(%{dataset_id: "12"}))
  end

  test "create_dataset uses systemName if given one" do
    assert %{technical: %{systemName: "something"}} =
             TDG.create_dataset(%{technical: %{systemName: "something"}})
  end
end
