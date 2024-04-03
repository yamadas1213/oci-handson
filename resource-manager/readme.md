# ハンズオン構成図
![Architecture](https://github.com/yamadas1213/oci-handson/assets/147447133/8664052c-ed42-42a0-8b69-f8a5e3ef1a1f)


## 前提条件
・実行ユーザにResource Managerを扱う権限が付与されていること  
・cloud Shellのホームディレクトリから各コマンドを実行すること  
※本ハンズオンでは作成するリソース名を任意の値でベタ書きしています。  
　同一テナンシで複数人で実施する場合には、コンパートメントを分けて実行するか該当のリソース名を変更してください。

## 手順
1. ハンズオンリソースのダウンロード
2. 公開鍵＆秘密鍵の作成と公開鍵の設定
3. ハンズオンリソースの圧縮
4. リソースマネージャへのアクセス
5. スタックの作成
6. ジョブの実行
7. 作成したリソースの確認

## 1. ハンズオンリソースのダウンロード

ハンズオンで使用するリソースをダウンロードします。
```rb
$ git clone https://github.com/yamadas1213/oci-handson.git
```

リソース構成は下記のようになっています。
```
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
```
$ mkdir oci-handson/resource-manager/source/modules/compute/.ssh
```
sshキー（公開鍵＆秘密鍵）の作成
```
$ ssh-keygen
```
公開鍵の移動
```
$ cp .ssh/id_rsa.pub oci-handson/resource-manager/source/modules/compute/.ssh/
```
公開鍵の確認
```
$ ls oci-handson/resource-manager/source/modules/compute/.ssh/
id_rsa.pub
```

## 3. ハンズオンリソースの圧縮

後にリソースマネージャにインポートするため、リソース群をまとめてzip圧縮します。
```
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

スタック作成ボタンを押下します。
![image](https://github.com/yamadas1213/oci-handson/assets/147447133/87f73982-d413-45d1-931f-07532533c8fc)

スタック作成画面が表示されるので、下記の手順でローカル環境にダウンロードしたリソースをアップロードします
![image](https://github.com/yamadas1213/oci-handson/assets/147447133/d33f20f5-1fa0-46e5-ab7e-c3b8c536ab4a)




