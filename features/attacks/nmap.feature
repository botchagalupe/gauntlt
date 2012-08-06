Feature: nmap attack
  Background:
    Given an attack "nmap" exists
    And a file named "simple_nmap.attack" with:
    """
    Attack: simple nmap attack (sanity check)

      Preparation:
        Given "nmap" is installed
        And the target hostname is "google.com"

      Tactic: Verify server is available on standard web ports
        When I launch an "nmap" attack with:
          \"\"\"
          nmap -p 80,443 <hostname>
          \"\"\"
        Then the output should contain:
          \"\"\"
          80/tcp  open  http
          443/tcp open  https
          \"\"\"
    """
    And a file named "os_detection_nmap.attack" with:
    """
    Attack: OS detection

      Preparation:
        Given "nmap" is installed
        And the target hostname is "google.com"

      @slow
      Tactic: Detect OS
        When I launch an "nmap" attack with:
          \"\"\"
          nmap -sV -p80 -PN <hostname>
          \"\"\"
        Then the output should contain:
          \"\"\"
          Service Info: OS: Linux
          \"\"\"
    """
    And a file named "tcp_ping_ports_nmap.attack" with:
    """
    Attack: nmap attacks for example.com
      Preparation:
        Given "nmap" is installed
        And the target hostname is "google.com"
        And the target tcp_ping_ports are "22,25,80,443"

      @slow
      Tactic: Using tcp syn ping scan and the nmap fast flag
        When I launch an "nmap" attack with:
          \"\"\"
          nmap -F -PS<tcp_ping_ports> <hostname>
          \"\"\"
        Then the output should contain:
          \"\"\"
          80/tcp
          \"\"\"

     """
    And a file named "xml_output_nmap.attack" with:
      """
      Attack: simple nmap attack (sanity check)

        Preparation:
          Given "nmap" is installed
          And the target hostname is "google.com"

        Tactic: Output to XML
          When I launch an "nmap" attack with:
            \"\"\"
            nmap -p 80,443 -oX foo.xml <hostname>
            \"\"\"
          And the file "foo.xml" should contain XML:
            | css                                                          |
            | ports port[protocol="tcp"][portid="80"] state[state="open"]  |
            | ports port[protocol="tcp"][portid="443"] state[state="open"] |
          And the file "foo.xml" should not contain XML:
            | css                                                          |
            | ports port[protocol="tcp"][portid="123"] state[state="open"] |
      """


  Scenario: Simple nmap attack
    When I run `gauntlt attack --name nmap --attack-file simple_nmap.attack`
    Then it should pass
    And the output should contain:
      """
      4 steps (4 passed)
      """

  @slow
  Scenario: OS detection nmap attack
    When I run `gauntlt attack -n nmap -a os_detection_nmap.attack`
    Then it should pass
    And the output should contain:
      """
      4 steps (4 passed)
      """

  Scenario: Testing the tcp_ping_ports
    When I run `gauntlt attack -n nmap -a tcp_ping_ports_nmap.attack`
    Then it should pass
    And the output should contain:
      """
      5 steps (5 passed)
      """

  Scenario: Handle XML output file
    When I run `gauntlt attack -n nmap -a xml_output_nmap.attack`
    Then it should pass
    And the output should contain:
      """
      5 steps (5 passed)
      """