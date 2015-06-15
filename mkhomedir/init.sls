{% set my_umask = '0077' %}
mkhomedir:
{% if grains['os_family'] == 'Debian' %}
  file.blockreplace:
    - name: /etc/pam.d/common-session
    - marker_start: '# START saltstack managed zone : -DO-NOT-EDIT-'
    - marker_end: '# END saltstack managed zone : --'
    - content: 'session     required      pam_mkhomedir.so skel=/etc/skel umask={{ my_umask }}'
    - show_changes: True
    - append_if_not_found: True
    - backup: '.saltbackup'

{% elif grains['os_family'] == 'RedHat' %}
  pkg.installed:
    - name: oddjob-mkhomedir

{% if salt['grains.get']('mkhomedir_authconfig') != True %}
mkhomedir-authconfig:
  cmd.run:
    - name: authconfig --enablemkhomedir --update
    - require:
      - pkg: oddjob-mkhomedir
  
  grains.present:
    - name: mkhomedir_authconfig
    - value: True
    - require:
      - cmd: mkhomedir-authconfig
{% endif %}

{% endif %}

