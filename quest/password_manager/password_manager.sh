#!/bin/bash

echo "パスワードマネージャーへようこそ！"
while [ ! "$choice" = "Exit" ]
do
    read -p "次の選択肢から入力してください(Add Password / Get Password / Exit)：" choice
    case "$choice" in
        'Add Password')
            read -p "サービス名を入力してください：" service_name
            read -p "ユーザー名を入力してください：" user_name
            read -p "パスワードを入力してください：" password
            echo "$service_name:$user_name:$password" >> ./file.txt
            echo "パスワードの追加は成功しました。"
            ;;
        'Get Password')
            read -p "サービス名を入力してください：" service_name
            service_record=$(grep "^$service_name" ./file.txt)
            if [ $service_record ]; then
                user_name=$(echo $service_record | cut -d : -f 2)
                password=$(echo $service_record | cut -d : -f 3)
                echo "サービス名：$service_name"
                echo "ユーザー名：$user_name"
                echo "パスワード：$password"
            else
                echo "そのサービスは登録されていません。"
            fi
            ;;
        'Exit')
            echo 'Thank you!'
            ;;
        *)
            echo '入力を間違えています。Add Password / Get Password / Exit から入力してください。'
            ;;
    esac
done