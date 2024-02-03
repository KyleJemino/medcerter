defmodule Medcerter.Prescriptions do
  alias Medcerter.Prescriptions.Resolvers.PrescriptionResolver, as: PR
  alias Medcerter.Prescriptions.Queries.PrescriptionQuery, as: PQ

  defdelegate get_prescription(id), to: PR
  defdelegate get_prescription_by_params(params \\ %{}), to: PR
  defdelegate list_prescriptions(params \\ %{}), to: PR
  defdelegate create_prescription(attrs \\ %{}), to: PR
  defdelegate change_prescription(prescription, attrs \\ %{}), to: PR
  defdelegate update_prescription(prescription, attrs \\ %{}), to: PR
  defdelegate prescription_update_change(prescription, attrs \\ %{}), to: PR
  defdelegate archive_prescription(prescription), to: PR
  defdelegate query_prescription(params \\ %{}), to: PQ
end
