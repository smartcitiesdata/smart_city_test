defmodule SmartCity.TestDataGenerator do
  @moduledoc """
  Module that generates test data for Smart City project.
  """

  alias SmartCity.TestDataGenerator.Payload

  defp dataset_example do
    title = "#{Faker.Color.fancy_name()}_#{Faker.Color.Es.name()}"
    org = "#{Faker.Color.It.name()}_#{Faker.Cat.name()}"

    schema = Payload.get_schema(:test)

    %{
      id: Faker.UUID.v4(),
      business: %{
        dataTitle: title,
        description: Faker.Lorem.Shakespeare.hamlet(),
        modifiedDate: Faker.Date.backward(360),
        orgTitle: org,
        contactName: Faker.Name.name(),
        contactEmail: Faker.Internet.email(),
        license: Faker.Util.pick(["Apache", "GNU", "BDS", "MIT"]),
        keywords: Faker.Util.list(5, &Faker.Company.buzzword/0),
        rights: Faker.Lorem.Shakespeare.as_you_like_it(),
        homepage: Faker.Internet.domain_name()
      },
      technical: %{
        dataName: title,
        orgName: org,
        orgId: Faker.UUID.v4(),
        systemName: "#{title}__#{org}",
        stream: false,
        schema: schema,
        sourceUrl: Faker.Internet.domain_name(),
        sourceFormat: Faker.Util.pick(["gtfs", "csv", "json"]),
        cadence: :rand.uniform(5_000),
        queryParams: %{apiKey: Faker.UUID.v4()},
        transformations: ["trim", "aggregate", "rename_field"],
        validations: ["matches_schema", "no_nulls"],
        headers: %{accepts: "application/json"},
        sourceType: "batch",
        private: false
      }
    }
  end

  def create_dataset(%{} = overrides) do
    {:ok, dataset} =
      dataset_example()
      |> SmartCity.Helpers.deep_merge(overrides)
      |> (fn map -> apply(SmartCity.Dataset, :new, [map]) end).()

    dataset
  end

  def create_dataset(term) do
    create_dataset(Map.new(term))
  end

  defp organization_example do
    org = "#{Faker.Color.It.name()}_#{Faker.Cat.name()}"

    %{
      id: Faker.UUID.v4(),
      orgTitle: org,
      orgName: String.downcase(org),
      description: Faker.Lorem.Shakespeare.hamlet(),
      logoUrl: "http://#{Faker.Internet.domain_name()}/logo.png",
      homepage: Faker.Internet.domain_name()
    }
  end

  def create_organization(%{} = overrides) do
    {:ok, organization} =
      organization_example()
      |> SmartCity.Helpers.deep_merge(overrides)
      |> (fn map -> apply(SmartCity.Organization, :new, [map]) end).()

    organization
  end

  def create_organization(term) do
    create_organization(Map.new(term))
  end

  defp data_example do
    start_time = DateTime.utc_now() |> DateTime.to_iso8601()
    end_time = DateTime.utc_now() |> DateTime.add(:rand.uniform(5_000)) |> DateTime.to_iso8601()
    payload = Payload.create_payload(:test)

    %{
      payload: payload,
      _metadata: %{org: Faker.Company.name(), name: Faker.Team.name()},
      operational: %{
        timing: [
          %{
            app: "reaper",
            label: "json_decode",
            start_time: start_time,
            end_time: end_time
          }
        ]
      }
    }
  end

  def create_data(%{} = overrides) do
    {:ok, data} =
      data_example()
      |> Map.merge(overrides)
      |> (fn map -> apply(SmartCity.Data, :new, [map]) end).()

    data
  end

  def create_data(term) do
    create_data(Map.new(term))
  end

  def create_data(overrides, number) do
    1..number
    |> Enum.map(fn _index -> create_data(overrides) end)
  end
end
