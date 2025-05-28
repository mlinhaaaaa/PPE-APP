from flask import Flask, request, jsonify, send_file
from flask_cors import CORS
import cv2
import torch
import numpy as np
from ultralytics import YOLO
import uuid
import os

app = Flask(__name__)
CORS(app)  # Cho phép CORS, để Flutter có thể gọi API

model = YOLO("best.pt")  # model YOLO của bạn

SELECTED_CLASSES = {
    0: "Earmuffs", 1: "Face", 2: "Face mask", 3: "Face-guard",
    4: "Foot", 5: "Glasses", 6: "Gloves", 7: "Hands", 8: "Head",
    9: "Helmet", 10: "Medical-suit", 11: "Person", 12: "Safety-vest",
    13: "Safety-suit", 14: "Tools"
}
REQUIRED_PPE = {"Helmet", "Safety-vest", "Face mask", "Safety-suit", "Gloves"}

OUTPUT_DIR = "outputs"
os.makedirs(OUTPUT_DIR, exist_ok=True)

def get_color_for_class(class_name):
    color_map = {
        "Helmet": (0, 255, 0),          # xanh lá
        "Safety-vest": (255, 165, 0),  # cam
        "Face mask": (0, 0, 255),       # đỏ
        "Safety-suit": (165, 42, 42),   # nâu
        "Gloves": (128, 0, 128),        # tím
        # Có thể thêm class khác nếu muốn
    }
    return color_map.get(class_name, (192, 192, 192))  # xám mặc định

@app.route('/detect', methods=['POST'])
def detect_ppe():
    if 'image' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400

    # Đọc ảnh từ file upload
    image_file = request.files['image']
    image_np = cv2.imdecode(np.frombuffer(image_file.read(), np.uint8), cv2.IMREAD_COLOR)

    # Chạy model detect
    results = model(image_np, conf=0.25, iou=0.35)[0]

    detected_classes = set()
    detections = []

    for box in results.boxes.data:
        x1, y1, x2, y2, score, class_id = map(float, box)
        class_id = int(class_id)
        if class_id in SELECTED_CLASSES:
            class_name = SELECTED_CLASSES[class_id]
            detected_classes.add(class_name)

            detections.append({
                "class_name": class_name,
                "score": score,
                "bbox": [int(x1), int(y1), int(x2), int(y2)]
            })

            color = get_color_for_class(class_name)
            # Vẽ hộp và tên PPE lên ảnh
            cv2.rectangle(image_np, (int(x1), int(y1)), (int(x2), int(y2)), color, 2)
            cv2.putText(image_np, class_name, (int(x1), int(y1) - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.6, color, 2)

    missing_ppe = REQUIRED_PPE - detected_classes

    # Lưu ảnh kết quả với tên file duy nhất để tránh cache hoặc trùng
    output_filename = f"output_{uuid.uuid4().hex[:8]}.jpg"
    output_path = os.path.join(OUTPUT_DIR, output_filename)
    cv2.imwrite(output_path, image_np)

    # Trả về dữ liệu JSON cho client
    return jsonify({
        "detections": detections,
        "missing_ppe": list(missing_ppe),
        "image_url": f"/outputs/{output_filename}"
    })

# Route để serve ảnh output
@app.route('/outputs/<filename>')
def get_output_image(filename):
    return send_file(os.path.join(OUTPUT_DIR, filename), mimetype='image/jpeg')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
