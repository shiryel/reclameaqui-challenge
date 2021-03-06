defmodule CS.ComplainsTest do
  use ExUnit.Case, async: true

  alias CS.Complains

  setup_all do
    Mongo.command(:mongo, %{dropDatabase: 1})
  end

  @valid_complain %{
    title: "A complain",
    description: "Plz read",
    company: %{name: "a company"},
    locale: %{country: "Brazil", state: "SP", city: "São José do Rio Preto"}
  }

  @valid_complain_result %{
    "company" => %{"name" => "a company"},
    "description" => "Plz read",
    "locale" => %{
      "city" => "São José do Rio Preto",
      "country" => "Brazil",
      "state" => "SP"
    },
    "title" => "A complain"
  }

  @invalid_complain_by_company_miss %{
    title: "A complain",
    description: "Plz read",
    locale: %{country: "Brazil", state: "SP", city: "São José do Rio Preto"}
  }

  @invalid_complain_by_company_name_miss %{
    title: "A complain",
    description: "Plz read",
    company: %{},
    locale: %{country: "Brazil", state: "SP", city: "São José do Rio Preto"}
  }

  @invalid_complain_by_locale_miss %{
    title: "A complain",
    description: "Plz read",
    company: %{name: "a company"}
  }

  @invalid_complain_by_locale_country_miss %{
    title: "A complain",
    description: "Plz read",
    company: %{name: "a company"},
    locale: %{state: "SP", city: "São José do Rio Preto"}
  }

  describe "create_complain" do
    test "(valid) create_complain/1" do
      result = Complains.create_complain(@valid_complain)

      assert {:ok, %{acknowledged: true}} == result
    end

    test "(invalid company) create_complain/1" do
      result = Complains.create_complain(@invalid_complain_by_company_miss)

      assert {:error, %{company: ["can't be blank"]}} == result
    end

    test "(invalid company name) create_complain/1" do
      result = Complains.create_complain(@invalid_complain_by_company_name_miss)

      assert {:error, %{company: %{name: ["can't be blank"]}}} == result
    end

    test "(invalid locale) create_complain/1" do
      result = Complains.create_complain(@invalid_complain_by_locale_miss)

      assert {:error, %{locale: ["can't be blank"]}} == result
    end

    test "(invalid locale country) create_complain/1" do
      result = Complains.create_complain(@invalid_complain_by_locale_country_miss)

      assert {:error, %{locale: %{country: ["can't be blank"]}}} == result
    end
  end

  describe "list_complains" do
    test "(valid) list_complains/2" do
      Complains.create_complain(@valid_complain)
      result = Complains.list_complains()

      assert Enum.member?(result, @valid_complain_result)
    end

    test "(valid) list_complains/2 with page opts" do
      Complains.create_complain(@valid_complain)
      result = Complains.list_complains(%{page: 2000000, size: 4})

      assert [] == result
    end

    test "(valid) list_complains_by_locale/3" do
      Complains.create_complain(@valid_complain)
      result = Complains.list_complains_by_locale(@valid_complain.locale)

      assert Enum.member?(result, @valid_complain_result)
    end

    test "(valid) list_complains_by_locale/3 with page opts" do
      Complains.create_complain(@valid_complain)
      result = Complains.list_complains_by_locale(@valid_complain.locale, %{size: 5, page: 1000000})

      assert [] == result
    end

    test "(valid) list_complains_by_locale_and_company/4" do
      Complains.create_complain(@valid_complain)

      result =
        Complains.list_complains_by_locale_and_company(
          @valid_complain.locale,
          @valid_complain.company
        )

      assert Enum.member?(result, @valid_complain_result)
    end

    test "(valid) list_complains_by_locale_and_company/4 with page opts" do
      Complains.create_complain(@valid_complain)

      result =
        Complains.list_complains_by_locale_and_company(
          @valid_complain.locale,
          @valid_complain.company,
          %{page: 5000000,
          size: 60}
        )

      assert [] == result
    end

    test "(invalid locale country) list_complains_by_locale/3" do
      Complains.create_complain(@valid_complain)
      result = Complains.list_complains_by_locale(@invalid_complain_by_locale_country_miss.locale)

      assert [] == result
    end

    test "(invalid company name) list_complains_by_locale_and_company/4" do
      Complains.create_complain(@valid_complain)

      result =
        Complains.list_complains_by_locale_and_company(
          @invalid_complain_by_company_name_miss.locale,
          @valid_complain.company
        )

      assert Enum.member?(result, @valid_complain_result)
    end

    test "(invalid locale country) list_complains_by_locale_and_company/4" do
      Complains.create_complain(@valid_complain)

      result =
        Complains.list_complains_by_locale_and_company(
          @valid_complain.locale,
          @invalid_complain_by_locale_country_miss.company
        )

      assert Enum.member?(result, @valid_complain_result)
    end

    test "(invalid locale country and company name) list_complains_by_locale_and_company/4" do
      Complains.create_complain(@valid_complain)

      result =
        Complains.list_complains_by_locale_and_company(
          @invalid_complain_by_locale_country_miss.locale,
          @invalid_complain_by_company_name_miss.company
        )

      assert [] == result
    end
  end
end
