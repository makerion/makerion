defmodule Makerion.PrintTest do
  use Makerion.DataCase

  alias Makerion.Print

  describe "print_files" do
    alias Makerion.Print.PrintFile

    @valid_attrs %{name: "some name", path: "some path"}
    @update_attrs %{name: "some updated name", path: "some updated path"}
    @invalid_attrs %{name: nil, path: nil}

    def print_file_fixture(attrs \\ %{}) do
      {:ok, print_file} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Print.create_print_file()

      print_file
    end

    test "list_print_files/0 returns all print_files" do
      print_file = print_file_fixture()
      assert Print.list_print_files() == [print_file]
    end

    test "get_print_file!/1 returns the print_file with given id" do
      print_file = print_file_fixture()
      assert Print.get_print_file!(print_file.id) == print_file
    end

    test "create_print_file/1 with valid data creates a print_file" do
      assert {:ok, %PrintFile{} = print_file} = Print.create_print_file(@valid_attrs)
      assert print_file.name == "some name"
      assert print_file.path == "some path"
    end

    test "create_print_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Print.create_print_file(@invalid_attrs)
    end

    test "update_print_file/2 with valid data updates the print_file" do
      print_file = print_file_fixture()
      assert {:ok, %PrintFile{} = print_file} = Print.update_print_file(print_file, @update_attrs)
      assert print_file.name == "some updated name"
      assert print_file.path == "some updated path"
    end

    test "update_print_file/2 with invalid data returns error changeset" do
      print_file = print_file_fixture()
      assert {:error, %Ecto.Changeset{}} = Print.update_print_file(print_file, @invalid_attrs)
      assert print_file == Print.get_print_file!(print_file.id)
    end

    test "delete_print_file/1 deletes the print_file" do
      print_file = print_file_fixture()
      assert {:ok, %PrintFile{}} = Print.delete_print_file(print_file)
      assert_raise Ecto.NoResultsError, fn -> Print.get_print_file!(print_file.id) end
    end

    test "change_print_file/1 returns a print_file changeset" do
      print_file = print_file_fixture()
      assert %Ecto.Changeset{} = Print.change_print_file(print_file)
    end
  end
end
