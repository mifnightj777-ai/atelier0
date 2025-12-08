require "application_system_test_case"

class FragmentsTest < ApplicationSystemTestCase
  setup do
    @fragment = fragments(:one)
  end

  test "visiting the index" do
    visit fragments_url
    assert_selector "h1", text: "Fragments"
  end

  test "should create fragment" do
    visit fragments_url
    click_on "New fragment"

    fill_in "Description", with: @fragment.description
    click_on "Create Fragment"

    assert_text "Fragment was successfully created"
    click_on "Back"
  end

  test "should update Fragment" do
    visit fragment_url(@fragment)
    click_on "Edit this fragment", match: :first

    fill_in "Description", with: @fragment.description
    click_on "Update Fragment"

    assert_text "Fragment was successfully updated"
    click_on "Back"
  end

  test "should destroy Fragment" do
    visit fragment_url(@fragment)
    accept_confirm { click_on "Destroy this fragment", match: :first }

    assert_text "Fragment was successfully destroyed"
  end
end
