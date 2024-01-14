defmodule Medcerter.Prescriptions do
  alias Medcerter.Prescriptions.Resolvers.PrescriptionResolver, as: PR

  defdelegate create_prescription(attrs \\ %{}), to: PR
  defdelegate change_prescription(prescription, attrs \\ %{}), to: PR
end
