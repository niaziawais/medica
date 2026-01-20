from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image as keras_image
import numpy as np
from PIL import Image
import io

# ==============================
# 🌿 Initialize FastAPI App
# ==============================
app = FastAPI(title="Medicinal Plant Classifier API")

# Allow CORS for Flutter / Web Clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # You can restrict to specific origins later
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ==============================
# 📦 Load Model
# ==============================
MODEL_PATH = "plant_classifier_medica.h5"

try:
    model = load_model(MODEL_PATH)
    print("✅ Model loaded successfully!")
except Exception as e:
    model = None
    print(f"❌ Error loading model: {e}")

# ==============================
# 🏷️ Class Labels
# ==============================
CLASS_NAMES = [
    'AloeVera', 'Arive-Dantu', 'Betel', 'Crape-Jasmine',
    'Mint', 'Neem', 'Oleander', 'Peepal',
    'Pomegranate', 'Tulsi', 'curry'
]

# ==============================
# 🖼️ Preprocessing Function
# ==============================
def preprocess_image(img: Image.Image, target_size=(128, 128)):
    """Resize, convert to array, normalize (no flattening!)"""
    img = img.resize(target_size)
    img_array = keras_image.img_to_array(img) / 255.0
    img_array = np.expand_dims(img_array, axis=0)  # Shape: (1, 128, 128, 3)
    return img_array

# ==============================
# 🔮 Prediction Endpoint
# ==============================
@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    if model is None:
        return JSONResponse(
            content={"status": "error", "message": "Model not loaded properly."},
            status_code=500
        )

    try:
        # Read image bytes
        img_bytes = await file.read()
        img = Image.open(io.BytesIO(img_bytes)).convert("RGB")

        # Preprocess
        processed_img = preprocess_image(img)

        # Predict
        preds = model.predict(processed_img)
        class_idx = int(np.argmax(preds, axis=1)[0])
        class_name = CLASS_NAMES[class_idx]
        confidence = round(float(np.max(preds)) * 100, 2)

        # ✅ Always return valid JSON
        return JSONResponse(
            content={
                "status": "success",
                "predicted_class": class_name,
                "confidence": confidence,
                "classes": CLASS_NAMES
            },
            status_code=200
        )

    except Exception as e:
        return JSONResponse(
            content={"status": "error", "message": str(e)},
            status_code=500
        )

# ==============================
# 🏠 Root Endpoint
# ==============================
@app.get("/")
async def root():
    return {"message": "Welcome to the Medicinal Plant Classifier API!"}

# ==============================
# 📋 Classes Endpoint
# ==============================
@app.get("/classes")
async def get_classes():
    return {"status": "success", "classes": CLASS_NAMES}

# ==============================
# 🚀 Run Command (for local testing)
# ==============================
# Run with:  uvicorn app:app --host 0.0.0.0 --port 5000 --reload
