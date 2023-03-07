defmodule Medcerter.VisitsTest do
  use Medcerter.DataCase

  describe "visits" do
    alias Medcerter.Visits
    alias Medcerter.Visits.Visit
    import Medcerter.VisitsFixtures 

    test "list_visits/0 returns all visits" do
      visit = visit_fixture()  
      visit_2 = visit_fixture()

      visits = Visits.list_visits()

      assert Enum.member?(visits, visit)
      assert Enum.member?(visits, visit_2)
    end

    test "get_visit/1 return correct visit" do
      %{id: id} = visit_fixture()

      visit = Visits.get_visit(id)

      assert visit.id === id
    end
  end
end
