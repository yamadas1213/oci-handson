# ハンズオン構成図
![Architecture](https://github.com/yamadas1213/oci-handson/assets/147447133/8664052c-ed42-42a0-8b69-f8a5e3ef1a1f)


# 前提条件
・実行ユーザにResource Managerを扱う権限が付与されていること  
・cloud Shellのホームディレクトリから各コマンドを実行すること  
※本ハンズオンでは作成するリソース名を任意の値でベタ書きしています。  
　同一テナンシで複数人で実施する場合には、コンパートメントを分けて実行するか該当のリソース名を変更してください。

# 手順
1. ハンズオンリソースのダウンロード
2. 公開鍵＆秘密鍵の作成と公開鍵の設定
3. ハンズオンリソースの圧縮
4. リソースマネージャへのアクセス
5. スタックの作成とジョブの実行
6. 作成したリソースの確認

## 1. ハンズオンリソースのダウンロード

ハンズオンで使用するリソースをダウンロードします。
```rb
$ git clone https://github.com/yamadas1213/oci-handson.git
```

リソース構成は下記のようになっています。
```rb
.
└── resource-manager
    ├── images（構成図等ハンズオンの実行手順で使用する画像）
    ├── readme.md（本ハンズオンの実行手順）
    └── source（Resource Managerのスタックにインプットするリソース群）
        ├── main.tf
        ├── modules
        │   ├── compute
        │   │   ├── cloudinit.yaml
        │   │   ├── compute.tf
        │   │   └── variable.tf
        │   └── vcn
        │       ├── output.tf
        │       ├── variable.tf
        │       └── vcn.tf
        ├── provider.tf
        └── variable.tf

```

## 2. 公開鍵＆秘密鍵の作成と公開鍵の設定

ローカル環境（Cloud Shell）上で公開鍵と秘密鍵を作成し、ComputeVMリソースの.sshディレクトリに公開鍵を格納します。 

ComputeVMリソースの.ssh ディレクトリの作成  
```rb
$ mkdir oci-handson/resource-manager/source/modules/compute/.ssh
```
sshキー（公開鍵＆秘密鍵）の作成
```rb
$ ssh-keygen
```
公開鍵の移動
```rb
$ cp .ssh/id_rsa.pub oci-handson/resource-manager/source/modules/compute/.ssh/
```
公開鍵の確認
```rb
$ ls oci-handson/resource-manager/source/modules/compute/.ssh/
id_rsa.pub
```

## 3. ハンズオンリソースの圧縮

後にリソースマネージャにインポートするため、リソース群をまとめてzip圧縮します。
```rb
$ zip -r resource-manager.zip oci-handson/resource-manager/source
  adding: oci-handson/resource-manager/source/ (stored 0%)
  adding: oci-handson/resource-manager/source/main.tf (deflated 57%)
  adding: oci-handson/resource-manager/source/modules/ (stored 0%)
  adding: oci-handson/resource-manager/source/modules/compute/ (stored 0%)
  adding: oci-handson/resource-manager/source/modules/compute/cloudinit.yaml (deflated 62%)
  adding: oci-handson/resource-manager/source/modules/compute/compute.tf (deflated 58%)
  adding: oci-handson/resource-manager/source/modules/compute/variable.tf (deflated 58%)
  adding: oci-handson/resource-manager/source/modules/compute/.ssh/ (stored 0%)
  adding: oci-handson/resource-manager/source/modules/compute/.ssh/id_rsa.pub (deflated 16%)
  adding: oci-handson/resource-manager/source/modules/vcn/ (stored 0%)
  adding: oci-handson/resource-manager/source/modules/vcn/output.tf (deflated 12%)
  adding: oci-handson/resource-manager/source/modules/vcn/variable.tf (deflated 58%)
  adding: oci-handson/resource-manager/source/modules/vcn/vcn.tf (deflated 78%)
  adding: oci-handson/resource-manager/source/provider.tf (deflated 51%)
  adding: oci-handson/resource-manager/source/variable.tf (deflated 58%)
$ ls
resource-manager.zip 
```
Cloud Shellからzipファイルをダウンロードします。

![image](https://github.com/yamadas1213/oci-handson/assets/147447133/2077c309-ce68-4e4f-ad49-89096a695403)


## 4. リソースマネージャへのアクセス

OCIコンソールにログインし、リソースマネージャのスタック画面に遷移します。

![image](https://github.com/yamadas1213/oci-handson/assets/147447133/7589c1a2-1d14-4dcc-a534-9189b28d3258)

## 5. スタックの作成
スタック作成ボタンを押下します。

![image](https://github.com/yamadas1213/oci-handson/assets/147447133/87f73982-d413-45d1-931f-07532533c8fc)

スタック作成画面が表示されるので、下記の手順でローカル環境にダウンロードしたリソースをアップロードします。

![image](https://github.com/yamadas1213/oci-handson/assets/147447133/d33f20f5-1fa0-46e5-ab7e-c3b8c536ab4a)

compartment_idが空欄になっているため、リソースを作成するコンパートメントIDを入力します。

![image](https://github.com/yamadas1213/oci-handson/assets/147447133/389f2057-8fad-4500-848b-d7abdc8b5445)

画面左下の次へボタンを押下します。

![image](https://github.com/yamadas1213/oci-handson/assets/147447133/41c03dbc-d037-425f-9689-e731d697731b)

前の画面で入力した変数の情報を確認し、「適用の実行」にチェックを入れて、画面下の「作成」ボタンを押下します。

![image](https://github.com/yamadas1213/oci-handson/assets/147447133/b2172c6d-8270-4ed0-8322-166bf334a464)

「作成」ボタンの押下後、ジョブの実行画面に遷移します。  

![image](https://github.com/yamadas1213/oci-handson/assets/147447133/b1ce3878-b385-496a-995d-3954999d5642)

ステータスが受入れ済から成功に変わったら実行成功です。

![image](https://github.com/yamadas1213/oci-handson/assets/147447133/069f1af5-f9ae-4772-b559-4d652394c040)

※実行に失敗している場合は、ログを確認してエラー箇所を調査してください。

## 6. 作成したリソースの確認

コンピュートの画面に遷移します。

![image](https://github.com/yamadas1213/oci-handson/assets/147447133/5a0144c3-df07-4bf6-85c2-9577da2fcaf0)

作成したCompute インスタンスの詳細画面に遷移し、パブリックIPをコピーします。

![image](https://github.com/yamadas1213/oci-handson/assets/147447133/6adb7107-28ae-41c3-a488-b2fee1445393)

Cloud Shellから、下記コマンドを実行し、ssh接続を行います。

```rb
$ ssh -i .ssh/id_rsa opc@<コピーしたIPアドレス>
FIPS mode initialized
The authenticity of host 'XXX.XXX.XX.XX (XXX.XXX.XX.XX)' can't be established.
ECDSA key fingerprint is SHA256:.
ECDSA key fingerprint is SHA1:.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'XXX.XXX.XX.XX' (ECDSA) to the list of known hosts.
Activate the web console with: systemctl enable --now cockpit.socket
[opc@handson-instance ~]$ pwd
/home/opc
```

ハンズオンシナリオは以上です。

