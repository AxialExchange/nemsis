require 'spec_helper'
require 'nemsis/renderer/wake_med/helpers/text_helper'

include Nemsis::Renderer::WakeMed::Helpers::TextHelper

describe Nemsis::Renderer::WakeMed::Helpers::TextHelper do

  it "stringifies nil" do
    expect(simple_format(nil)).to eq('')
  end

  it "stringifies non-strings" do
    expect(simple_format(3.14)).to eq('3.14')
  end

  it "escapes HTML tags" do
    expect(simple_format('<b>')).to eq('&lt;b&gt;')
  end

  it "strips leading and trailing whitespace" do
    expect(simple_format(" \t \n  blah \n \v ")).to eq('blah')
  end

  it "converts newlines to <br> tags" do
    expect(simple_format("now\nis the\n\ntime")).to eq('now<br>is the<br><br>time')
  end

  it "converts leading spaces on a line to &nbsp; entities" do
    expect(simple_format("Stooges:\n  Larry\n  Moe\n  Curly")).to eq('Stooges:<br>&nbsp;&nbsp;Larry<br>&nbsp;&nbsp;Moe<br>&nbsp;&nbsp;Curly')
  end

end
