module ApiKeysHelper
  def api_key_button_status(value)
    value ? "Disable" : "Enable"
  end

  def api_key_status(value)
    value ? "Active" : "Disabled"
  end
end
