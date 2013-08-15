class Criterion < ActiveRecord::Base
  Option = Struct.new(:description, :value, :label)

  belongs_to :evaluation

  serialize :options, Array

  def self.establish(title, options)
    create(title: title, options: options)
  end

  def scale
    @scale ||= construct_scale
  end

  def construct_scale
    result = []
    options.each_with_index do |description, i|
      result << Option.new(description, i, tag(i))
    end
    result.reverse
  end

  private

  def tag(i)
    %w(Poor Fair Good Great)[i]
  end
end
