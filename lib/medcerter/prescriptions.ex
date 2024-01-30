defmodule Medcerter.Prescriptions do
  alias Medcerter.Prescriptions.Resolvers.PrescriptionResolver, as: PR

  defdelegate get_prescription(attrs \\ %{}), to: PR
  defdelegate create_prescription(attrs \\ %{}), to: PR
  defdelegate change_prescription(prescription, attrs \\ %{}), to: PR
  defdelegate update_prescription(prescription, attrs \\ %{}), to: PR
  defdelegate prescription_update_change(prescription, attrs \\ %{}), to: PR
  defdelegate archive_prescription(prescription), to: PR
end
