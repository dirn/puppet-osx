# Public: Disable capslock on attached keyboards.
#
# Example
#
#   include osx::keyboard::disable_capslock
#
class osx::keyboard::disable_capslock {
  # Disable capslock on all attached keyboards
  $keyboard_ids = 'ioreg -n IOHIDKeyboard -r | grep -E \'VendorID"|ProductID\' | awk \'{ print $4 }\' | paste -s -d\'-\n\' -'
  $check = 'xargs -I{} sh -c \'defaults -currentHost read -g "com.apple.keyboard.modifiermapping.{}-0" | grep "Dst = -1" > /dev/null\''
  $disable = 'xargs -I{} defaults -currentHost write -g "com.apple.keyboard.modifiermapping.{}-0" -array "<dict><key>HIDKeyboardModifierMappingDst</key><integer>-1</integer><key>HIDKeyboardModifierMappingSrc</key><integer>0</integer></dict>"'
  exec { 'Disable capslock on all keyboards':
    command => "${keyboard_ids} | ${disable}",
    unless  => "${keyboard_ids} | ${check}"
  }
}
