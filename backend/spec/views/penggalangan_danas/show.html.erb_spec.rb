require 'rails_helper'

RSpec.describe "penggalangan_danas/show", type: :view do
  before(:each) do
    assign(:penggalangan_dana, PenggalanganDana.create!(
      title: "Title",
      body: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
