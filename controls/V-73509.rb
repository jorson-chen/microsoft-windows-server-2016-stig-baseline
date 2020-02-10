control 'V-73509' do
  title "Hardened UNC paths must be defined to require mutual authentication
  and integrity for at least the \\\\*\\SYSVOL and \\\\*\\NETLOGON shares."
  desc "Additional security requirements are applied to Universal Naming
  Convention (UNC) paths specified in hardened UNC paths before allowing access
  to them. This aids in preventing tampering with or spoofing of connections to
  these paths."
  impact 0.5
  tag "gtitle": 'SRG-OS-000480-GPOS-00227'
  tag "gid": 'V-73509'
  tag "rid": 'SV-88161r1_rule'
  tag "stig_id": 'WN16-CC-000090'
  tag "fix_id": 'F-79951r1_fix'
  tag "cci": ['CCI-000366']
  tag "nist": ['CM-6 b', 'Rev_4']
  tag "documentable": false
  desc "check", "This requirement is applicable to domain-joined systems. For
  standalone systems, this is NA.

  If the following registry values do not exist or are not configured as
  specified, this is a finding.

  Registry Hive: HKEY_LOCAL_MACHINE
  Registry Path:
  \\SOFTWARE\\Policies\\Microsoft\\Windows\\NetworkProvider\\HardenedPaths\\

  Value Name: \\\\*\\NETLOGON
  Value Type: REG_SZ
  Value: RequireMutualAuthentication=1, RequireIntegrity=1

  Value Name: \\\\*\\SYSVOL
  Value Type: REG_SZ
  Value: RequireMutualAuthentication=1, RequireIntegrity=1

  Additional entries would not be a finding."
  desc "fix", "Configure the policy value for Computer Configuration >>
  Administrative Templates >> Network >> Network Provider >> Hardened UNC
  Paths to Enabled with at least the following configured in Hardened UNC
  Paths: (click the Show button to display)

  Value Name: \\\\*\\SYSVOL
  Value: RequireMutualAuthentication=1, RequireIntegrity=1

  Value Name: \\\\*\\NETLOGON
  Value: RequireMutualAuthentication=1, RequireIntegrity=1"
  is_domain = command('wmic computersystem get domain | FINDSTR /V Domain').stdout.strip

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\NetworkProvider\\HardenedPaths') do
    it { should have_property '\\\\*\\NETLOGON' }
  end if is_domain != 'WORKGROUP'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\NetworkProvider\\HardenedPaths') do
    its('\\\\*\\NETLOGON') { should match(/RequireMutualAuthentication=1, RequireIntegrity=1/) }
  end if is_domain != 'WORKGROUP'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\NetworkProvider\\HardenedPaths') do
    it { should have_property '\\\\*\\SYSVOL' }
  end if is_domain != 'WORKGROUP'

  describe registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE\\Policies\\Microsoft\\Windows\\NetworkProvider\\HardenedPaths') do
    its('\\\\*\\SYSVOL') { should match(/RequireMutualAuthentication=1, RequireIntegrity=1/) }
  end if is_domain != 'WORKGROUP'

  if is_domain == 'WORKGROUP'
    impact 0.0
    desc 'This system is not joined to a domain, therfore this control is not appliable as it does not apply to standalone systems'
  end
end
