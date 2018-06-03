replayd-group:
  group.present:
    - name: replayd
    - gid: 4000

replayd-user:
  user.present:
    - name: replayd
    - shell: /usr/sbin/nologin
    - home: /nonexistent
    - uid: 4000
    - gid: 4000
    - groups:
      - replayd

/etc/hello-saltstack/:
  file.directory:
    - user: replayd
    - group: replayd
    - mode: 755
    - makedirs: True

/usr/local/bin/hello-saltstack:
  file.managed:
    - source: salt://web/hello-saltstack
    - user: replayd
    - group: replayd
    - mode: 755
    - show_changes: False

/etc/systemd/system/hello-saltstack.service:
  file.managed:
    - source: salt://web/hello-saltstack.service
    - user: replayd
    - group: replayd
    - mode: 644
    - show_changes: False

/etc/hello-saltstack/config.yaml:
  file.managed:
    - source: salt://web/config.yaml
    - user: replayd
    - group: replayd
    - mode: 644
    - show_changes: False

hello-saltstack:
  service.running:
    - enable: True
    - watch:
      - file: /usr/local/bin/hello-saltstack
      - file: /etc/systemd/system/hello-saltstack.service
      - file: /etc/hello-saltstack/config.yaml
