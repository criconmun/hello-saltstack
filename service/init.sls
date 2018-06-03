/usr/local/bin/hello-saltstack:
  file.managed:
    - source: salt://web/hello-saltstack
    - user: root
    - group: root
    - mode: 755
    - show_changes: False

/etc/systemd/system/hello-saltstack.service:
  file.managed:
    - source: salt://web/hello-saltstack.service
    - user: root
    - group: root
    - mode: 644
    - show_changes: False

hello-saltstack:
  service.running:
    - enable: True
    - watch:
      - file: /usr/local/bin/hello-saltstack
