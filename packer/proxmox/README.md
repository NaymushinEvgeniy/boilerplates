## Versions
Ivan - первая тестовая конфигурация со стоковой Ubuntu Server 20.04.5 LTS (10.03.2023)
Для работы с proxmox обязательна установка qemu-guest-agent.

## Генерация образов
Для работы необходим packer v.1.8.6 и более
Создаем файл с кред-ами по шаблону (заполнеям свои, кавычки должны выжить):

```
proxmox_api_url = "https://192.168.0.228:8006/api2/json"  #  Proxmox IP Address
proxmox_api_token_id = "root@pam!packer"  # API Token from use Proxmox API
proxmox_api_token_secret = "4a4i" # Secret torken for user
password = "megasecret"
```

Модифицируем конфиги под себя и проверяем:

`packer validate -var-file="../credentials.pkr.hcl" centos-server-ivan.pkr.hcl`

Если все ок - запускаем билд образа:

`packer build -var-file="../credentials.pkr.hcl" centos-server-ivan.pkr.hcl`