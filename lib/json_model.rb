require 'json_model/version'
require 'json'
require 'json/add/core'

module JsonModel

  def self.included(base)
    base.extend ClassMethods

    base.send(:field, :id)
  end

  module ClassMethods

    def attr_accessor(*vars)
      @attributes ||= []
      @attributes.concat vars
      super(*vars)
    end

    def attributes
      @attributes
    end

    def field(name)
      attr_accessor name
    end

    def all
      entries = []
      for entry in load_entries
        entries << create_object(entry)
      end

      entries
    end

    def find(value, key='id')
      entry = all.find{|e| e.send(key) == value }
    end

    def find_by(hash)
      if hash.instance_of? Hash
        hash.each {| key, value | return find(value, key) }
      end
    end

    def new_id
      ids = all.map(&:id)
      ids.max.to_i + 1
    end

    def filename=(str)
      @filename = str
    end

    def filename
      @filename ||= "#{ancestors.first}.json".downcase
      File.expand_path(@filename)
    end


    protected


    def save(entry)
      entries = all

      if entry.new_record?
        # new record
        entry.id = ancestors.first.send(:new_id)
        entries.push(entry)
      else
        # update record
        index = entries.index {|e| e.id == entry.id }
        entries[index] = entry
      end

      save_entries(entries)
      entry
    end

    def destroy(entry)
      entries = all

      if entry.respond_to?(:id)
        index = entries.index {|e| e.id == entry.id }
        entries.delete_at(index)
        save_entries(entries)
        return true
      end

      false
    end

    def load_entries
      entries = []
      if File.exists?(filename)
        file = File.read(filename)
        file = '[]' if file.length.zero?
        entries = JSON.parse(file)
      end

      entries
    end

    def save_entries(entries)
      File.open(filename,"w") do |f|
        f.write(entries.to_json)
      end
    end

    def create_object(entry)
      self.send(:new, entry)
    end
  end

  def initialize(atts={})
    atts.each do |k,v|
      instance_variable_set("@#{k}", v)
    end
  end

  def attributes
    self.class.attributes
  end

  def save
    self.class.send(:save, self)
  end

  def destroy
    self.class.send(:destroy, self)
  end

  def new_record?
    self.id.nil?
  end

  def to_json(*a)
      hash = {}
      self.instance_variables.each do |var|
          key = var.to_s.delete '@'
          hash[key] = self.instance_variable_get var
      end
      hash.to_json(*a)
  end

end