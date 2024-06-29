# i2p-conection-frame
Um modelo de filtro de rede anônima I2P e como aplicá-lo na sua internet para manter o anonimato e proteger seus dados sensíveis contra espionagem, além de como acessar as camadas inferiores da deep web e dark web. Também cobre outras camadas de segurança, usando proxychains para não mostrar seu endereço IP.
> [!WARNING]
> É interessante também usar o Veracrypt e VPNs se você for entrar nas camadas inferiores. Tenha cuidado com suas ações.

![images](https://github.com/thaleshodan/i2p-conection-frame/assets/173853965/c6d3e8b3-2928-4ba7-b0c9-9d09bb53abec)

I2P (Invisible Internet Project) é uma rede de anonimato que permite a comunicação segura e privada através da Internet. Ao contrário da navegação tradicional na web, onde os dados podem ser monitorados e rastreados, o I2P utiliza um conjunto de técnicas avançadas para proteger a identidade e a localização dos seus utilizadores,Semelhante ao Tor, o I2P utiliza o roteamento onion  para criptografar as comunicações em várias camadas. No entanto, ao invés de direcionar o tráfego através da internet pública, o I2P cria uma rede interna de roteadores que transmitem mensagens de forma anônima.

O I2P emprega uma técnica chamada roteamento (garlic), onde múltiplas mensagens são agrupadas em um único pacote criptografado. Isso dificulta ainda mais a correlação entre remetente e destinatário, aumentando o anonimato Para cada conexão, o I2P estabelece túneis de entrada e de saída separados, o que significa que o caminho dos dados de entrada é diferente do caminho dos dados de saída. Esse método impede que qualquer nó intermediário tenha conhecimento completo do percurso das mensagens. 

Privacidade e Anonimato: O I2P é amplamente utilizado por indivíduos e organizações que buscam proteger sua privacidade e evitar censura. Isso inclui jornalistas, ativistas, e cidadãos em países com regimes opressivos.

Segurança de Dados: A criptografia forte e o roteamento descentralizado do I2P protegem os dados contra interceptação e monitoramento, tornando-o uma escolha robusta para comunicações seguras.

Resiliência a Censura: Por ser uma rede distribuída e anônima, o I2P é resistente a tentativas de censura e bloqueio por parte de governos ou outras entidades.

## INSTALAÇÃO DA I2P NO WINDOWS

- acessar a pagína da i2p  https://geti2p.net/en/
- baixar arquivo .exe no seu navegador
- executar o arquivo .exe

## CONFIGURAÇÃO DA REDE I2P NO WINDOWS

Após a instalação, abra o atalho do I2P que foi criado no menu Iniciar ou na área de trabalho.<br>
O I2P iniciará e abrirá uma página web no seu navegador padrão (geralmente em http://127.0.0.1:7657

## INSTALAÇÃO DA REDE I2P NO LINUX 

adicionar repo I2P

```bash
echo "deb http://deb.i2p2.de/ unstable main" | sudo tee /etc/apt/sources.list.d/i2p.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xE6C1A57B
```

ATUALIZAR OS PACOTES DO LINUX
```bash
sudo apt-get update
```

instalar a conexão I2P
```bash
sudo apt-get install i2p
```

INICIALIZAR A CONEXÃO I2P
```bash
sudo service i2p start
```
