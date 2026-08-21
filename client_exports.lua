-- Basic

-- Inventory
exports("GetInventoryItemCount", _G.GetInventoryItemCount)

local txd = CreateRuntimeTxd("aquiver_cfx")
CreateRuntimeTextureFromImage(txd, "interaction_bg", "txd/interaction_bg.png")
