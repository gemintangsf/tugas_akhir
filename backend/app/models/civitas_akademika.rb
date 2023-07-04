class CivitasAkademika
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Attributes::Dynamic

    field :nama, type: String
    field :nomor_induk, type: String
end
  