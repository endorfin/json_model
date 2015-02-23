require 'minitest_helper'
require 'json_model'

  class MyModel
    include JsonModel

    field :name
  end

describe "Test including JsonModel" do

  before do
    filename = File.expand_path('mymodel.json')
    FileUtils.rm(filename) if File.exists?(filename)
  end

  let(:mymodel) { MyModel.new({name: 'Test'}) }


  it "has a version number" do
    refute_nil ::JsonModel::VERSION
  end

  it "includes JsonModel" do
    assert MyModel.ancestors.include?(JsonModel)
  end

  it "initialize with {name: 'Test'}" do
    assert_equal mymodel.name, 'Test'
  end

  it "do not initialize with {test: 'Test'}" do
    assert_raises(NoMethodError) do
      model = MyModel.new({title: 'Test'})
      assert_equal model.title, 'Test'
    end
  end

  it "has a id attribute after initialize, that is nil" do
    mymodel.id.must_be_nil
  end

  it "respond to new_record?" do
    mymodel.must_respond_to :new_record?
  end

  it "is new after initialize" do
    assert mymodel.new_record?
  end

  it "filename method returns mymodel.json" do
    filename = File.expand_path('mymodel.json')
    MyModel.filename.must_equal filename
  end

  it "filename can be overwritten" do
    assert_send [MyModel, :filename=, 'test.json']
  end

  it "has a 'all' ClassMethod which returns an empty Array" do
    assert_empty MyModel.all
  end

  it "new_id returns entries id max value + 1" do
    retval = MyModel.send(:new_id)
    retval.must_equal 1
  end

  it "has a 'save' ClassMethod which receives to object" do
    assert_send [MyModel, :save, mymodel]
  end

  it "returns the entry after save" do
    retval = MyModel.send(:save, mymodel)
    assert_instance_of MyModel, retval
  end

  it "has a 'save' method which calls the MyModel.save" do
    retval = mymodel.save
    assert_instance_of MyModel, retval
  end

  it "has a to_json" do
    retval = mymodel.to_json
    retval.must_equal '{"name":"Test"}'
  end

  it "created a mymodel.json on save_entries" do
    entries = []
    MyModel.send(:save_entries, entries)
    filename = MyModel.filename
    retval = File.exists?(filename)
    assert retval
  end

  it "load_entries returns 1 entry after save" do
    mymodel.save
    entries = MyModel.send(:load_entries)
    entries.size.must_equal 1
  end

  it "has an id after save" do
    mymodel.save
    mymodel.id.wont_be_nil
  end

  it "is not a new_record? after safe" do
    retval = mymodel.save
    assert_equal retval.new_record?, false
  end

  it "find entry by id and return nil if not exists" do
    retval = MyModel.find(100)
    retval.must_be_nil
  end

  it "find returns entry if exists" do
    mymodel.save
    retval = MyModel.find(1)
    assert_instance_of MyModel, retval
  end

  it "instance respond to attributes" do
    mymodel.must_respond_to :attributes
  end

  it "list all attributes, set by 'field' method" do
    assert_equal mymodel.attributes, [:id, :name]
  end

  it "find_by other fields than id" do
    mymodel.save
    retval = MyModel.find_by(name: 'Test')
    assert_instance_of MyModel, retval
  end

  it "find_by returns nil if not found" do
    retval = MyModel.find_by(name: 'Test')
    retval.must_be_nil
  end

  it "save updates entry, and not create a new entry" do
    mymodel.save
    mymodel.save
    MyModel.all.size.must_equal 1
  end

  it "save updates, if it's not a new entry" do
    mymodel.save
    mymodel.name = 'Updated'
    mymodel.save
    retval = MyModel.find(mymodel.id)
    retval.name.must_equal 'Updated'
  end

  it "object respond to destroy" do
    mymodel.must_respond_to :destroy
  end

  it "instance respond to destroy" do
    mymodel.save
    assert_send [mymodel, :destroy]
  end

  it "found 3 entries using find_all(name: 'Test')" do
    MyModel.new({name: 'Test'}).save
    MyModel.new({name: 'Fake'}).save
    MyModel.new({name: 'Test'}).save
    MyModel.new({name: 'Test'}).save

    #retval = MyModel.all
    retval = MyModel.find_all(name: 'Test')
    retval.size.must_equal 3
  end

end