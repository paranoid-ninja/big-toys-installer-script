BOT_TOKEN=$1
SERVER_IP_ADRESS=$2
MONGO_URI=$3

if [ $# -lt 3 ]; then
  echo 1>&2 "$0: Не все параметры указаны, проверьте, указаны-ли через пробел в верном порядке все 3 аргумента. (Токен_бота Айпи_сервера Ссылка_на_базу_данных)"
  exit 2
fi;

mkdir bot;
cd bot/;
sudo apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates;
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -;
sudo apt -y install nodejs;
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -;
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list;
sudo apt update && sudo apt install yarn;
source ~/.profile;
npm install pm2@latest -g;
git clone https://github.com/Scylin232/big-toys-telegram.git;
git clone https://github.com/Scylin232/big-toys-admin.git;
cd big-toys-telegram/;
echo '' > .env;
cat > .env << EOF
BOT_TOKEN="$BOT_TOKEN"
MONGO_URI="$MONGO_URI"
REDIS_URL="redis://bittoysdb:yT7RrtGnadwl69TlHglLHzvWkZG5ftBP@redis-18039.c91.us-east-1-3.ec2.cloud.redislabs.com:18039"
BOT_ALIAS="bigToysShopTelegram"
EOF
yarn install;
yarn build;
pm2 start node ./dist/app.js;
cd ..;
cd big-toys-admin/;
yarn install;
cat > env.js << EOF
const envimorent = {
  apiUrl: '$SERVER_IP_ADRESS'
}

export default envimorent
EOF
yarn build;
pm2 start app.js --name "front";
echo "Адмие панель запущена по ссылке: http://${SERVER_IP_ADRESS}:4201/";
