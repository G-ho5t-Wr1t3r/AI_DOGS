# Base debian image
FROM node:20-bookworm

# Set terminal colors
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

ENV CLAUDE_CONFIG_DIR=/home/node/.claude

RUN apt-get update && apt-get install -y \
    curl \
    tree \
    nano \
    micro \
    git \
    || (echo "Apt failed" && exit 1)

RUN npm install -g @anthropic-ai/claude-code || (echo "NPM failed" && exit 1)

RUN mkdir -p /home/node/.claude/skills/claudio /home/node/.claude/hooks /home/node/.config || (echo "Mkdir failed" && exit 1)
COPY --chown=node:node CLAUDE.md /home/node/.claude/CLAUDE.md
COPY --chown=node:node .claudio/settings.json /home/node/.claude/settings.json
COPY --chown=node:node .claudio/claudio/SKILL.md /home/node/.claude/skills/claudio/SKILL.md
COPY --chown=node:node .claudio/hooks/claudio-session-start.sh /home/node/.claude/hooks/claudio-session-start.sh
RUN chmod +x /home/node/.claude/hooks/claudio-session-start.sh

# Set working directory
WORKDIR /app

RUN mkdir -p /app/context /mnt/host_context /app/output /app/utility || (echo "Mkdir failed" && exit 1)

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY utility.sh /app/utility/utility.sh
RUN chmod +x /usr/local/bin/entrypoint.sh /app/utility/utility.sh || (echo "Chmod failed" && exit 1)

RUN chown -R node:node /home/node /app /mnt || (echo "Chown failed" && exit 1)
RUN chmod 777 /app/output || (echo "Chmod output failed" && exit 1)

USER node

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
