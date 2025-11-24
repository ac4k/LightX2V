#!/bin/bash
# Wan2.2 T2V 14B weight NVFP4 quantization script（weight-only quantization）
# Usage: ./quantize_weight_nvfp4.sh <original model path> <output path>

set -e

#### just for colorful terminal output ####
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
#### color setting end ####

if [ $# -lt 2 ]; then
    echo -e "${RED}Error: missing parameters${NC}"
    echo "Usage: $0 <original model path> <output path>"
    echo "Example: $0 /data/models/wan2.2_t2v_14b /data/models/wan2.2_t2v_14b_nvfp4"
    exit 1
fi

SOURCE_MODEL=$1
OUTPUT_MODEL=$2
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "Original model path: $SOURCE_MODEL"
echo "Output model path: $OUTPUT_MODEL"
echo ""

if [ ! -d "$SOURCE_MODEL" ]; then
    echo -e "${RED}Error: original model path does not exist: $SOURCE_MODEL${NC}"
    exit 1
fi

mkdir -p "$OUTPUT_MODEL"

echo -e "${YELLOW}Start converting model to NVFP4 format (weight-only quantization)...${NC}"
echo ""

cd "$SCRIPT_DIR"
python3 tools/convert/converter.py \
    --source "$SOURCE_MODEL" \
    --output "$OUTPUT_MODEL" \
    --output_ext .safetensors \
    --output_name wan2.2_t2v_14b_nvfp4 \
    --model_type wan_dit \
    --quantized \
    --linear_quant_type NVFP4 \
    --non_linear_dtype torch.bfloat16 \
    --save_by_block || {
    echo -e "${RED}Error: model conversion failed${NC}"
    exit 1
}

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Quantization completed!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Quantized model location: $OUTPUT_MODEL"
echo ""
echo "File list:"
ls -lh "$OUTPUT_MODEL" | head -10
echo ""
echo -e "${YELLOW}Note: This is weight-only quantization, activation is not quantized${NC}"
echo ""

