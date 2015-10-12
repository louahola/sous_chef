require 'spec_helper'

describe command('ruby --version')  do
	its(:stdout){ should match 'ruby 2.2.*' }
end