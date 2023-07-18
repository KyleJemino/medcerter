defmodule Medcerter.Visits.Resolvers.VisitResolver do
  import Medcerter.Visits.Queries.VisitQuery
  alias Medcerter.Repo
  alias Medcerter.Visits.Visit

  def list_visits(params \\ %{}) do
    params
    |> query_visit()
    |> Repo.all()
  end

  def get_visit(id) do
    %{"id" => id}
    |> query_visit()
    |> Repo.one()
  end

  def create_visit(attrs \\ %{}) do
    %Visit{}
    |> Visit.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_visit(%Visit{} = visit, params) do
    visit
    |> Visit.changeset(attrs)
    |> Repo.update()
  end

  def change_visit(%Visit{} = visit, attrs \\ %{}) do
    Visit.changeset(visit, attrs)
  end
end
