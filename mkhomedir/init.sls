{% set my_umask = '0770' %}
mkhomedir:
{% if grains['os'] == 'Debian' %}
  file.blockreplace:
    - name: /etc/pam.d/common-session
    - marker_start: '# START saltstack managed zone : -DO-NOT-EDIT-'
    - marker_end: '# END saltstack managed zone : --'
    - content: 'session     required      pam_mkhomedir.so skel=/etc/skel umask={{ my_umask }}'
    - show_changes: True
    - append_if_not_found: True
    - backup: '.saltbackup'

{% elif grains['os_family'] == 'RedHat' %}
  oddjob_mkhomedir:
    pkg.installed
  
  cmd.run:
    - name: /sbin/authconfig --enablemkhomedir --update
{% endif %}

