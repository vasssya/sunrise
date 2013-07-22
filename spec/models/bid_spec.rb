require 'spec_helper'

describe Bid do
	# TODO subject { described_class.make! }
 #  it { should be_valid }
  it { should belong_to :user }
end
