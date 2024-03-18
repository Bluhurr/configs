set -U fish_greeting "🐟 FISH 🐟"

function web-main-pull
  eval (ssh-agent -c)
  ssh-add ~/.ssh/id_github
  git pull origin main
end
