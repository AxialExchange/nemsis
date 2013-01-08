require 'spec_helper'
require 'nemsis/renderer/wake_med/helpers/text_helper'

include Nemsis::Renderer::WakeMed::Helpers::TextHelper

describe Nemsis::Renderer::WakeMed::Helpers::TextHelper do

  it "stringifies nil" do
    simple_format(nil).should == ''
  end

  it "stringifies non-strings" do
    simple_format(3.14).should == '3.14'
  end

  it "escapes HTML tags" do
    simple_format('<b>').should == '&lt;b&gt;'
  end

  it "strips leading and trailing whitespace" do
    simple_format(" \t \n  blah \n \v ").should == 'blah'
  end

  it "converts newlines to <br> tags" do
    simple_format("now\nis the\n\ntime").should == 'now<br>is the<br><br>time'
  end

  it "converts leading spaces on a line to &nbsp; entities" do
    simple_format("Stooges:\n  Larry\n  Moe\n  Curly").should == 'Stooges:<br>&nbsp;&nbsp;Larry<br>&nbsp;&nbsp;Moe<br>&nbsp;&nbsp;Curly'
  end

end
