class V1::CivitasAkademikaController < ApplicationController
  def importExcelCivitasAkademika
    if params[:file].present? && File.extname(params[:file].original_filename) == '.xlsx'
        import_data(params[:file].tempfile)
        render json: {
            response_code: Constants::RESPONSE_CREATED, 
            response_message: "Success",
            }, status: :created
    else
        render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Import Excel Gagal!"
            }, status: :unprocessable_entity
    end
  end

  def getAllCivitasAkademika
    civitas_akademika = CivitasAkademika.all
    if not civitas_akademika.present?
        render json: {
            response_code: Constants::ERROR_CODE_VALIDATION,
            response_message: "Tidak ada data!"
            }, status: :unprocessable_entity
    else
        render json: {
            response_code: Constants::RESPONSE_SUCCESS, 
            response_message: "Success",
            data: civitas_akademika
            }, status: :ok
    end
  end

  private

  def import_data(file)
    xls = Roo::Excelx.new(file.path)
    xls.each_row_streaming(offset: 1) do |row|
      nama = row[1]&.value
      nomor_induk = row[0]&.value
      CivitasAkademika.create!(nama: nama, nomor_induk: nomor_induk)
    end
  end
end