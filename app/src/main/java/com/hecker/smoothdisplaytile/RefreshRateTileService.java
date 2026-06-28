package com.hecker.smoothdisplaytile;

import android.service.quicksettings.Tile;
import android.service.quicksettings.TileService;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

public class RefreshRateTileService extends TileService {

    private static final String CONF    = "/data/adb/smoothdisplay/mode.conf";
    private static final String TILE_SH = "/data/adb/modules/SmoothDisplayToggle/tile.sh";

    @Override
    public void onStartListening() {
        super.onStartListening();
        updateTile();
    }

    @Override
    public void onClick() {
        super.onClick();
        runTileScript();
        // Give tile.sh ~600ms to write the new conf, then refresh label
        new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(
            this::updateTile, 600
        );
    }

    /**
     * Run tile.sh as root and wait for it to finish.
     * Using waitFor() ensures mode.conf is written before updateTile() reads it.
     */
    private void runTileScript() {
        try {
            Process p = Runtime.getRuntime().exec(new String[]{"su", "-c", "sh " + TILE_SH});
            p.waitFor();
        } catch (IOException | InterruptedException e) {
            // Root not granted or script missing
        }
    }

    /**
     * Read mode.conf via root so SELinux/permissions never block us.
     * Falls back to "auto" on any error.
     */
    private String readMode() {
        try {
            Process p = Runtime.getRuntime().exec(
                new String[]{"su", "-c", "cat " + CONF}
            );
            BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
            String line = br.readLine();
            br.close();
            if (line != null && !line.trim().isEmpty()) return line.trim();
        } catch (IOException e) {
            // fall through
        }
        return "auto";
    }

    private void updateTile() {
        Tile tile = getQsTile();
        if (tile == null) return;
        String mode = readMode();
        switch (mode) {
            case "90hz":
                tile.setLabel("90Hz");
                tile.setSubtitle("Forced");
                tile.setState(Tile.STATE_ACTIVE);
                break;
            case "60hz":
                tile.setLabel("60Hz");
                tile.setSubtitle("Forced");
                tile.setState(Tile.STATE_INACTIVE);
                break;
            default:
                tile.setLabel("Smooth Display");
                tile.setSubtitle("Auto");
                tile.setState(Tile.STATE_ACTIVE);
                break;
        }
        tile.updateTile();
    }
}
