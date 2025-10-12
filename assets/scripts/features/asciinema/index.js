import * as AsciinemaPlayer from 'asciinema-player';

document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.asciinema').forEach(el => {
        const src = el.dataset.src;
        const cols = parseInt(el.dataset.cols) || 80;
        const rows = parseInt(el.dataset.rows) || 24;
        const autoplay = el.dataset.autoplay === "true";
        const loop = el.dataset.loop === "true";
        const theme = el.dataset.theme || "asciinema";

        AsciinemaPlayer.create(
                src,
                el,
                {
                    cols: cols,
                    rows: rows,
                    autoplay: autoplay,
                    loop: loop,
                    theme: theme,
                    terminalFontFamily: "'FiraCode Nerd Font Mono', monospace",
                    fit: "both"
                }
                );
    });
});
