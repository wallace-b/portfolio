# load dependencies
import numpy as np
import sklearn
import joblib
from flask import Flask, render_template, request

# Create flask app
app = Flask(__name__)

# Specify particular models
MODELS = ["DH Hierarchical Linear Model", "Random Forest All"]

# Specify feature names
FEATURES = ["viewers", "pageviews", "viewtime", "chats", "likes", "clicks"]

# Specify feature ranges (min, max)  and units
FEATURES_MIN_MAX = [
    [520, 266270, "count"],
    [613, 293050, "count"],
    [24.35238, 960.02037, "seconds"],
    [0, 105875, "count"],
    [0, 225468, "count"],
    [17, 150736, "count"],
]

# Load the model
model_all = joblib.load("all_platforms_best_model.joblib")


@app.route("/", methods=["GET", "POST"])
# def index():
#     return render_template("index.html", )


def predict_rev():
    prediction_result = None
    if request.method == "POST":
        # Initialize empty list to store feature vals
        test_point = []
        # Obtain input values from the html form
        for i, feature in enumerate(FEATURES):
            # scale feature value to 0-1 range
            feature_val = (float(request.form[feature]) - FEATURES_MIN_MAX[i][0]) / (
                FEATURES_MIN_MAX[i][1] - FEATURES_MIN_MAX[i][0]
            )
            test_point.append(feature_val)
        # Prep input data
        test_point_np = np.array(test_point).reshape(1, -1)
        prediction_rev = model_all.predict(test_point_np)
        prediction_result = round(prediction_rev[0], 2)

    return render_template(
        "index.html",
        models=MODELS,
        features=FEATURES,
        features_min_max=FEATURES_MIN_MAX,
        prediction_result=prediction_result,
    )


# "<p>The estimated revenue of the marketing campaign is ${}.</p>".format()

if __name__ == "__main__":
    app.run()
