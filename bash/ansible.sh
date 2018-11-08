# create new ansible role
ansible-new-role()
{
  local role_name=$1 f dir

  if [[ -z $role_name || $role_name == "-h" ]]; then 
    cat<<EOT
Create ansible skeleton configureation.
Get this help message:
   ansible-new-role -h
Create empty files only:
   ansible-new-role <role> -k
Create populated files and playbooks entry:
   ansible-new-role <role>
EOT
  return -1

  fi
  mkdir -p roles/"$role_name"/{defaults,handlers,tasks,templates,files,meta}
  for dir in defaults handlers tasks meta; do
    f="roles/$role_name/$dir/$role_name-$dir.yml"
    case $dir in
      meta)
        cat<<EOT >"$f"
---
dependencies: []
EOT
        if [[ $2 != "-k" ]]; then
        cat<<EOT >"$f"
---
dependencies:
  - role: firewalld
    firewalld_allow:
      - '{{ ${role_name//-/_}_service_port }}/tcp'"
EOT
        fi
      ;;
      tasks)
        echo '---' > "$f"
        if [[ $2 != "-k" ]]; then
          cat<<EOT >> "$f"
- name: Install $role_name
  yum:
    name: '{{ ${role_name//-/_}_service_package }}'
    state: present
  tags: [yum, $role_name]

- name: Configure $role_name
  template:
    src: $role_name.conf.j2
    dest: '{{ ${role_name//-/_}_service_config }}'
  tags: [config, $role_name]

- name: Enable and start $role_name
  service:
    name: '{{ ${role_name//-/_}_service_name }}.service'
    enabled: yes
    state: started
  tags: [service, $role_name]
EOT
        fi
      ;;
      defaults)
        echo '---' > "$f"
        if [[ $2 != "-k" ]]; then
          cat<<EOT >> "$f"
${role_name//-/_}_service_name: $role_name
${role_name//-/_}_service_package: $role_name
${role_name//-/_}_service_config: /etc/$role_name.conf
${role_name//-/_}_service_port:
EOT
        fi
      ;;
      handlers)
        echo "---" > "$f"
        if [[ $2 != "-k" ]]; then
          cat<<EOT >> "$f"
- name: restart $role_name
  service:
    name: '{{ ${role_name//-/_}_service_name }}.service'
    state: restarted"
EOT
        fi
      ;;
      *) echo '---' > "$f";;
    esac
    ln -s "$role_name-$dir.yml" "roles/$role_name/$dir/main.yml"
    xdg-open "roles/$role_name/$dir/$role_name-$dir.yml"
  done

  if [[ $2 != "-k" ]]; then
    f="roles/$role_name/templates/${role_name}.conf.j2"
    cat<<EOT > "$f"
{
      src: "${role_name}.conf.j2"
}
EOT
    xdg-open $f

    mkdir -p playbooks
    cat<<EOT >>"playbooks/${role_name}.yml"
- hosts: "{{ target | default('${role_name//-/_}') }}"
  gather_facts: no
  roles: [${role_name}]
EOT
    xdg-open "playbooks/${role_name}.yml"
  fi 
}
