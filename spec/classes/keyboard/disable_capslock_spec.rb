require 'spec_helper'

describe 'osx::keyboard::disable_capslock' do
  let(:command_str) do
    "ioreg -n IOHIDKeyboard -r | grep -E 'VendorID\"|ProductID' | " \
    "awk '{ print $4 }' | paste -s -d'-\\n' - | xargs -I{} defaults " \
    "-currentHost write -g \"com.apple.keyboard.modifiermapping.{}-0\" " \
    "-array \"<dict><key>HIDKeyboardModifierMappingDst</key>" \
    "<integer>-1</integer><key>HIDKeyboardModifierMappingSrc</key>" \
    "<integer>0</integer></dict>\""
  end

  let(:unless_str) do
    "ioreg -n IOHIDKeyboard -r | grep -E 'VendorID\"|ProductID' | " \
    "awk '{ print $4 }' | paste -s -d'-\\n' - | xargs -I{} sh -c 'defaults" \
    " -currentHost read -g \"com.apple.keyboard.modifiermapping.{}-0\" | " \
    "grep \"Dst = -1\" > /dev/null'"
  end

  it do
    should contain_exec('Disable capslock on all keyboards').
      with(:command => command_str, :unless => unless_str)
  end

end
