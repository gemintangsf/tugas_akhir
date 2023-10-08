class RekapitulasiBeasiswaHasDonasi < ApplicationRecord
    self.table_name = 'penanggungjawabnonbeasiswa_has_penerimanonbeasiswa'
    
    belongs_to :donasi, class_name: "Donasi"
    belongs_to :rekapitulasi_beasiswa, class_name: "RekapitulasiBeasiswa"
end
