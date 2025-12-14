# config files - too lazy to make a proper readme icl

## kitty config

## sddm greeter theme

How to install the sddm theme:

### 1. cd into the directory of ur download
### 2. Extract the content
```
tar -xvf sddm-theme.tar.gz
``` 
### 3. move it to the themes directory

```
sudo mv TerminalStyleLogin /usr/share/sddm/themes/
```

### 4. configure the greeter config
```
sudo nano /etc/sddm.conf
```

_and add the following line:_
```
[Theme]

Current=TerminalStyleLogin
```

### restart sddm service via
```
sudo systemctl restart sddm.service
```


automation script coming soon
