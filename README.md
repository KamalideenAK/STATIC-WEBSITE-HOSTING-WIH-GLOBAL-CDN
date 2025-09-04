# Static-Website-Hosting-with-Global-CDN
Deploy a secure, production‑ready static site on Amazon S3 with global delivery via Amazon CloudFront. Includes TLS with AWS Certificate Manager, IAM/S3 access controls, and reproducible IaC using Terraform. Ideal for marketing, media, or educational sites.

# Static Website Hosting with Global CDN

**Project name:** Static Website Hosting with Global CDN

**Industry:** Marketing / Media / Education

**Overview**

Host a secure, production-ready static website (company site / portfolio) on **Amazon S3** and deliver it globally with **Amazon CloudFront**. The project demonstrates secure static hosting, TLS via **AWS Certificate Manager (ACM)**, access control via **IAM** and **S3 bucket policies**, and reproducible Infrastructure-as-Code using **Terraform**. Ideal for marketing teams, media portfolios, or educational project pages.

---

## Problem statement

Many organizations need a low-cost, globally-distributed static website with strong security and an easy deployment story. The requirements are:

* Serve HTML/CSS/JS and media quickly to users worldwide.
* Ensure HTTPS everywhere with managed certificates.
* Keep origin storage private so only CDN can read objects.
* Reproducible infrastructure provisioning and CI/CD for deployers.
* Low monthly operational cost and clear cost visibility.

This repo provides a reference implementation — secure by default, production-ready caching, and a small CI pipeline to publish site updates and purge CDN cache.

---

## Architecture (high-level)

{"type":"excalidraw/clipboard","workspaceId":"lbPhtEymsBzNbaEPcIFk","elements":[{"modifiedBy":"","modifiedAt":1757001476560,"id":"c_nf9dW1EgwcRTnAE2kXW","x":0,"y":0,"version":4,"versionNonce":1083640097,"renderVersion":"20250904","seed":1,"zIndex":0,"diagramType":"cloud-architecture-diagram","code":"title AWS Static Website Delivery & CI/CD Architecture\n\nInternet [icon: globe] {\n  Browser [icon: monitor, label: \"User Browser\"]\n}\n\nAWS Edge [icon: aws-cloudfront] {\n  CloudFront Distribution [icon: aws-cloudfront, label: \"CloudFront\"]\n}\n\nAWS Region [icon: aws] {\n  ACM [icon: aws-certificate-manager, label: \"ACM (TLS Cert)\"]\n  S3 Bucket [icon: aws-s3, label: \"S3 (static-site-bucket)\"]\n  CloudFront OAI [icon: aws-cloudfront, label: \"OAI / OAC\"]\n  Route 53 [icon: aws-route-53, label: \"Route 53\"]\n  IAM CI Deployer [icon: aws-iam, label: \"IAM: CI Deployer\"]\n  CloudFront Logs [icon: aws-cloudwatch, label: \"CloudFront Logs\"]\n  CloudTrail [icon: aws-cloudtrail]\n  Billing Alarm [icon: aws-cloudwatch, label: \"Billing Alarm\"]\n}\n\nCI [icon: github] {\n  GitHub Actions [icon: github]\n}\n\n// Connections: User request flow\nBrowser > CloudFront Distribution: HTTPS request\nCloudFront Distribution > S3 Bucket: Origin fetch (OAI)\nCloudFront Distribution > ACM: Uses TLS cert\n\n// Connections: CI/CD deployment\nIAM CI Deployer > GitHub Actions: AssumeRole\n\n// Connections: Logging & monitoring\nCloudFront Distribution > CloudFront Logs: Access logs\nS3 Bucket > CloudTrail: Object, versioning\nCloudTrail > Billing Alarm: Audit logs\nCloudFront Distribution < Route 53: Alias / A record\nS3 Bucket < GitHub Actions: aws s3 sync + invalidation\nCloudFront Distribution < GitHub Actions: CreateInvalidation\n","width":1574.5199432373047,"height":740.67,"boundElementIds":[],"isDeleted":false,"type":"diagram","opacity":100,"angle":0,"roughness":1,"shouldApplyRoughness":true,"groupIds":[],"lockedGroupId":null,"diagramId":null,"containerId":null,"figureId":null,"fillStyle":"solid","backgroundColor":"transparent","strokeColor":"#d7d9dc","strokeWidth":1,"strokeStyle":"solid","strokeSharpness":"round","isBeingGenerated":false,"forceAiMode":false,"isSyntaxMissing":false,"isSyntaxBroken":false,"scale":1},{"id":"ebe34e464ff9431ff156466eab3b5044","strokeColor":"#c38424","backgroundColor":"rgba(253,251,246, 1)","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"round","roughness":0,"opacity":100,"elementStyle":1,"colorMode":0,"diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"Internet","type":"rectangle","isContainer":true,"diagramRole":"group","sizingMode":"auto","compound":{"type":"parent","containerType":"group","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"INTERNET","icon":{"name":"globe"}}},"x":15,"y":381.75,"width":117.83192443847656,"height":144,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":623709569,"version":2,"versionNonce":1615090479,"isDeleted":false,"boundElementIds":null,"modifiedAt":1757001476559,"figureId":null,"zIndex":1},{"id":"210c1c880a8ce932487f59961006f114","containerId":"ebe34e464ff9431ff156466eab3b5044","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"Browser","diagramRole":"node","strokeColor":"#242424","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"name":"monitor","customStyle":false,"x":48.91596221923828,"y":431.75,"compound":{"type":"parent","containerType":"cad-node","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"User Browser","icon":{"name":"monitor"}}},"type":"icon","width":50,"height":50,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":514323457,"version":3,"versionNonce":1289655151,"isDeleted":false,"boundElementIds":["7152401d16ae10c262fc2e38ec51779c"],"modifiedAt":1757001476559,"figureId":null,"zIndex":2},{"id":"32443373b8376eeb7b46df6e68cb07bd","strokeColor":"#c38424","backgroundColor":"rgba(253,251,246, 1)","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"round","roughness":0,"opacity":100,"elementStyle":1,"colorMode":0,"diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"AWS Edge","type":"rectangle","isContainer":true,"diagramRole":"group","sizingMode":"auto","compound":{"type":"parent","containerType":"group","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"AWS EDGE","icon":{"name":"aws-cloudfront"}}},"x":314.6528015136719,"y":381.75,"width":153.42596435546875,"height":144,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":1272615201,"version":2,"versionNonce":1933638465,"isDeleted":false,"boundElementIds":null,"modifiedAt":1757001476559,"figureId":null,"zIndex":3},{"id":"1e415ed9a5ebf9b05c0f11142d3cfb3c","containerId":"32443373b8376eeb7b46df6e68cb07bd","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"CloudFront Distribution","diagramRole":"node","strokeColor":"#242424","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"name":"aws-cloudfront","customStyle":true,"x":341.36578369140625,"y":431.75,"compound":{"type":"parent","containerType":"cad-node","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"CloudFront","icon":{"name":"aws-cloudfront"}}},"type":"icon","width":50,"height":50,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":1068083137,"version":3,"versionNonce":1687805697,"isDeleted":false,"boundElementIds":["7152401d16ae10c262fc2e38ec51779c","4dd50441f9b02f87e13b624d48b3b552","04effa503aa1ae0728816ddd8a3de8aa","40f62be9f17a6fdbb82b59daf7c960c3","8d85f591ba49de917f07734f9cfea65f","84071f7ff04ba7228388a8dca224e301"],"modifiedAt":1757001476559,"figureId":null,"zIndex":4},{"id":"7152401d16ae10c262fc2e38ec51779c","type":"arrow","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-Browser-CloudFront Distribution-forward-HTTPS request","strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"elbow","roughness":0,"opacity":100,"arrowHeadSize":12,"shouldApplyRoughness":true,"startArrowhead":null,"endArrowhead":"arrow","cardinalElbowData":{"isEnabled":true},"points":[[0,0],[242,0]],"x":98.91596221923828,"y":456.75,"diagramCodeElement":{"from":"Browser","to":"CloudFront Distribution","relationshipType":"FORWARD","label":"HTTPS request"},"lastCommittedPoint":null,"startBinding":{"elementId":"210c1c880a8ce932487f59961006f114","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[1,0],"direction":"right"}},"endBinding":{"elementId":"1e415ed9a5ebf9b05c0f11142d3cfb3c","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[-1.0179928588867186,0],"direction":"left"}},"width":242,"height":0,"angle":0,"groupIds":["4a97795e7582f7a6a5f1c934b78f9621"],"lockedGroupId":"4a97795e7582f7a6a5f1c934b78f9621","seed":1130805473,"version":2,"versionNonce":148634145,"isDeleted":false,"boundElementIds":null,"textGap":[83.41233825683594,-9.5,82.828125,18],"modifiedAt":1757001476560,"figureId":null,"zIndex":5},{"strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"scale":1,"fontSize":13,"parentElementMetadata":{"elementId":"7152401d16ae10c262fc2e38ec51779c","type":"arrow"},"fontFamily":2,"textAlign":"center","verticalAlign":"middle","id":"59b22739256c125700be9231d0b9a6cc","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-Browser-CloudFront Distribution-forward-HTTPS request","x":183.32830047607422,"y":448.25,"text":"HTTPS request","type":"textbox","width":80.828125,"height":16,"angle":0,"groupIds":["4a97795e7582f7a6a5f1c934b78f9621"],"lockedGroupId":"4a97795e7582f7a6a5f1c934b78f9621","seed":371622319,"version":3,"versionNonce":2123428975,"isDeleted":false,"boundElementIds":null,"mode":"normal","hasFixedBounds":true,"modifiedAt":1757001476560,"figureId":null,"zIndex":6},{"id":"3ebb2d8b4eee76f455645bf00fdd652e","strokeColor":"#c38424","backgroundColor":"rgba(253,251,246, 1)","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"round","roughness":0,"opacity":100,"elementStyle":1,"colorMode":0,"diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"AWS Region","type":"rectangle","isContainer":true,"diagramRole":"group","sizingMode":"auto","compound":{"type":"parent","containerType":"group","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"AWS REGION","icon":{"name":"aws"}}},"x":700.2735748291016,"y":15,"width":554.094482421875,"height":657,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":672086209,"version":2,"versionNonce":433067343,"isDeleted":false,"boundElementIds":null,"modifiedAt":1757001476559,"figureId":null,"zIndex":7},{"id":"752ebcb6ec33fd6ecf3850843ad05958","containerId":"3ebb2d8b4eee76f455645bf00fdd652e","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"ACM","diagramRole":"node","strokeColor":"#242424","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"name":"aws-certificate-manager","customStyle":true,"x":728.5125350952148,"y":312,"compound":{"type":"parent","containerType":"cad-node","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"ACM (TLS Cert)","icon":{"name":"aws-certificate-manager"}}},"type":"icon","width":50,"height":50,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":1327590273,"version":3,"versionNonce":834162063,"isDeleted":false,"boundElementIds":["04effa503aa1ae0728816ddd8a3de8aa"],"modifiedAt":1757001476559,"figureId":null,"zIndex":8},{"id":"04effa503aa1ae0728816ddd8a3de8aa","type":"arrow","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudFront Distribution-ACM-forward-Uses TLS cert","strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"elbow","roughness":0,"opacity":100,"arrowHeadSize":12,"shouldApplyRoughness":true,"startArrowhead":null,"endArrowhead":"arrow","cardinalElbowData":{"isEnabled":true},"points":[[0,0],[32,0],[122,0],[122,-92],[274,-92],[274,-111],[337,-111]],"x":391.36578369140625,"y":448.4166666666667,"diagramCodeElement":{"from":"CloudFront Distribution","to":"ACM","relationshipType":"FORWARD","label":"Uses TLS cert"},"lastCommittedPoint":null,"startBinding":{"elementId":"1e415ed9a5ebf9b05c0f11142d3cfb3c","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[1,-0.3333333333333326],"direction":"right"}},"endBinding":{"elementId":"752ebcb6ec33fd6ecf3850843ad05958","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[-1.0058700561523437,0.016666666666667426],"direction":"left"}},"width":337,"height":111,"angle":0,"groupIds":["45ef3af5cc559010e25e379292fb4c16"],"lockedGroupId":"45ef3af5cc559010e25e379292fb4c16","seed":17266817,"version":2,"versionNonce":854238689,"isDeleted":false,"boundElementIds":null,"textGap":[164.34944915771484,-103.3366666666667,76.921875,18],"modifiedAt":1757001476560,"figureId":null,"zIndex":9},{"strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"scale":1,"fontSize":13,"parentElementMetadata":{"elementId":"04effa503aa1ae0728816ddd8a3de8aa","type":"arrow"},"fontFamily":2,"textAlign":"center","verticalAlign":"middle","id":"d2fceda8c10310dc00076ebf411a9e3d","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudFront Distribution-ACM-forward-Uses TLS cert","x":556.7152328491211,"y":346.08,"text":"Uses TLS cert","type":"textbox","width":74.921875,"height":16,"angle":0,"groupIds":["45ef3af5cc559010e25e379292fb4c16"],"lockedGroupId":"45ef3af5cc559010e25e379292fb4c16","seed":262867983,"version":3,"versionNonce":1122231471,"isDeleted":false,"boundElementIds":null,"mode":"normal","hasFixedBounds":true,"modifiedAt":1757001476560,"figureId":null,"zIndex":10},{"id":"f958c69f8edd53ca27b7d03f7afb9074","containerId":"3ebb2d8b4eee76f455645bf00fdd652e","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"S3 Bucket","diagramRole":"node","strokeColor":"#242424","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"name":"aws-simple-storage-service","customStyle":true,"x":728.5125350952148,"y":179,"compound":{"type":"parent","containerType":"cad-node","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"S3 (static-site-bucket)","icon":{"name":"aws-s3"}}},"type":"icon","width":50,"height":50,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":315309889,"version":3,"versionNonce":518543073,"isDeleted":false,"boundElementIds":["d883fc4eab479749f846d613c1c30038","4dd50441f9b02f87e13b624d48b3b552","6a5e3bfdcf928fae50bb16c29aa7b95d"],"modifiedAt":1757001476559,"figureId":null,"zIndex":11},{"id":"4dd50441f9b02f87e13b624d48b3b552","type":"arrow","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudFront Distribution-S3 Bucket-forward-Origin fetch (OAI)","strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"elbow","roughness":0,"opacity":100,"arrowHeadSize":12,"shouldApplyRoughness":true,"startArrowhead":null,"endArrowhead":"arrow","cardinalElbowData":{"isEnabled":true},"points":[[0,0],[32,0],[112,0],[112,-170],[274,-170],[274,-236],[337,-236]],"x":391.36578369140625,"y":440.0833333333333,"diagramCodeElement":{"from":"CloudFront Distribution","to":"S3 Bucket","relationshipType":"FORWARD","label":"Origin fetch (OAI)"},"lastCommittedPoint":null,"startBinding":{"elementId":"1e415ed9a5ebf9b05c0f11142d3cfb3c","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[1,-0.6666666666666674],"direction":"right"}},"endBinding":{"elementId":"f958c69f8edd53ca27b7d03f7afb9074","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[-1.0058700561523437,0.0033333333333325755],"direction":"left"}},"width":337,"height":236,"angle":0,"groupIds":["cab4f03fc4829c59a07ba7624c8871b7"],"lockedGroupId":"cab4f03fc4829c59a07ba7624c8871b7","seed":1617458127,"version":2,"versionNonce":645533185,"isDeleted":false,"boundElementIds":null,"textGap":[156.20882415771484,-183.16333333333333,93.203125,18],"modifiedAt":1757001476560,"figureId":null,"zIndex":12},{"strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"scale":1,"fontSize":13,"parentElementMetadata":{"elementId":"4dd50441f9b02f87e13b624d48b3b552","type":"arrow"},"fontFamily":2,"textAlign":"center","verticalAlign":"middle","id":"0e48ab138253f5b7fb9d9278cec320c5","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudFront Distribution-S3 Bucket-forward-Origin fetch (OAI)","x":548.5746078491211,"y":257.91999999999996,"text":"Origin fetch (OAI)","type":"textbox","width":91.203125,"height":16,"angle":0,"groupIds":["cab4f03fc4829c59a07ba7624c8871b7"],"lockedGroupId":"cab4f03fc4829c59a07ba7624c8871b7","seed":258258081,"version":3,"versionNonce":544640655,"isDeleted":false,"boundElementIds":null,"mode":"normal","hasFixedBounds":true,"modifiedAt":1757001476560,"figureId":null,"zIndex":13},{"id":"f42392ce2af6753cb4924a47982fca89","containerId":"3ebb2d8b4eee76f455645bf00fdd652e","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"CloudFront OAI","diagramRole":"node","strokeColor":"#242424","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"name":"aws-cloudfront","customStyle":true,"x":728.5125350952148,"y":65,"compound":{"type":"parent","containerType":"cad-node","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"OAI / OAC","icon":{"name":"aws-cloudfront"}}},"type":"icon","width":50,"height":50,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":291709697,"version":3,"versionNonce":1670759343,"isDeleted":false,"boundElementIds":null,"modifiedAt":1757001476560,"figureId":null,"zIndex":14},{"id":"5a95fcfc4f25b78949acb906aabc45a8","containerId":"3ebb2d8b4eee76f455645bf00fdd652e","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"Route 53","diagramRole":"node","strokeColor":"#242424","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"name":"aws-route-53","customStyle":true,"x":728.5125350952148,"y":578,"compound":{"type":"parent","containerType":"cad-node","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"Route 53","icon":{"name":"aws-route-53"}}},"type":"icon","width":50,"height":50,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":1386550977,"version":3,"versionNonce":475845313,"isDeleted":false,"boundElementIds":["8d85f591ba49de917f07734f9cfea65f"],"modifiedAt":1757001476560,"figureId":null,"zIndex":15},{"id":"8d85f591ba49de917f07734f9cfea65f","type":"arrow","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudFront Distribution-Route 53-backward-Alias / A record","strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"elbow","roughness":0,"opacity":100,"arrowHeadSize":12,"shouldApplyRoughness":true,"startArrowhead":"arrow","endArrowhead":null,"cardinalElbowData":{"isEnabled":true},"points":[[0,0],[32,0],[122,0],[122,125],[274,125],[274,138],[337,138]],"x":391.36578369140625,"y":465.0833333333333,"diagramCodeElement":{"from":"CloudFront Distribution","to":"Route 53","relationshipType":"BACKWARD","label":"Alias / A record"},"lastCommittedPoint":null,"startBinding":{"elementId":"1e415ed9a5ebf9b05c0f11142d3cfb3c","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[1,0.3333333333333326],"direction":"right"}},"endBinding":{"elementId":"5a95fcfc4f25b78949acb906aabc45a8","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[-1.0058700561523437,0.0033333333333303017],"direction":"left"}},"width":337,"height":138,"angle":0,"groupIds":["602c513fee989214c4c441422c61b003"],"lockedGroupId":"602c513fee989214c4c441422c61b003","seed":2129202319,"version":2,"versionNonce":1477870977,"isDeleted":false,"boundElementIds":null,"textGap":[161.72444915771484,113.49666666666673,82.171875,18],"modifiedAt":1757001476560,"figureId":null,"zIndex":16},{"strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"scale":1,"fontSize":13,"parentElementMetadata":{"elementId":"8d85f591ba49de917f07734f9cfea65f","type":"arrow"},"fontFamily":2,"textAlign":"center","verticalAlign":"middle","id":"a22f92f3ad5f77b8b1c4b1c6848199ae","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudFront Distribution-Route 53-backward-Alias / A record","x":554.0902328491211,"y":579.58,"text":"Alias / A record","type":"textbox","width":80.171875,"height":16,"angle":0,"groupIds":["602c513fee989214c4c441422c61b003"],"lockedGroupId":"602c513fee989214c4c441422c61b003","seed":157747169,"version":3,"versionNonce":1050627855,"isDeleted":false,"boundElementIds":null,"mode":"normal","hasFixedBounds":true,"modifiedAt":1757001476560,"figureId":null,"zIndex":17},{"id":"860266f3a0faf048a7995bbf1ee3e8c6","containerId":"3ebb2d8b4eee76f455645bf00fdd652e","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"IAM CI Deployer","diagramRole":"node","strokeColor":"#242424","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"name":"aws-identity-and-access-management","customStyle":true,"x":1173.4761123657227,"y":316,"compound":{"type":"parent","containerType":"cad-node","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"IAM: CI Deployer","icon":{"name":"aws-iam"}}},"type":"icon","width":50,"height":50,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":525146753,"version":3,"versionNonce":44004815,"isDeleted":false,"boundElementIds":["8efabbed6de7b950a5f007dbdc37faca"],"modifiedAt":1757001476560,"figureId":null,"zIndex":18},{"id":"a5222128a5aa4cdb57f04f6e565d765b","containerId":"3ebb2d8b4eee76f455645bf00fdd652e","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"CloudFront Logs","diagramRole":"node","strokeColor":"#242424","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"name":"aws-cloudwatch","customStyle":true,"x":728.5125350952148,"y":445,"compound":{"type":"parent","containerType":"cad-node","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"CloudFront Logs","icon":{"name":"aws-cloudwatch"}}},"type":"icon","width":50,"height":50,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":1092038209,"version":3,"versionNonce":295096993,"isDeleted":false,"boundElementIds":["40f62be9f17a6fdbb82b59daf7c960c3"],"modifiedAt":1757001476560,"figureId":null,"zIndex":19},{"id":"40f62be9f17a6fdbb82b59daf7c960c3","type":"arrow","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudFront Distribution-CloudFront Logs-forward-Access logs","strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"elbow","roughness":0,"opacity":100,"arrowHeadSize":12,"shouldApplyRoughness":true,"startArrowhead":null,"endArrowhead":"arrow","cardinalElbowData":{"isEnabled":true},"points":[[0,0],[132,0],[132,-19],[274,-19],[274,13],[337,13]],"x":391.36578369140625,"y":456.75,"diagramCodeElement":{"from":"CloudFront Distribution","to":"CloudFront Logs","relationshipType":"FORWARD","label":"Access logs"},"lastCommittedPoint":null,"startBinding":{"elementId":"1e415ed9a5ebf9b05c0f11142d3cfb3c","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[1,0],"direction":"right"}},"endBinding":{"elementId":"a5222128a5aa4cdb57f04f6e565d765b","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[-1.0058700561523437,-0.01],"direction":"left"}},"width":337,"height":32,"angle":0,"groupIds":["ee563396b4e848ff230125628e93dc45"],"lockedGroupId":"ee563396b4e848ff230125628e93dc45","seed":1739119649,"version":2,"versionNonce":915497377,"isDeleted":false,"boundElementIds":null,"textGap":[170.24788665771484,-28.75,65.125,18],"modifiedAt":1757001476560,"figureId":null,"zIndex":20},{"strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"scale":1,"fontSize":13,"parentElementMetadata":{"elementId":"40f62be9f17a6fdbb82b59daf7c960c3","type":"arrow"},"fontFamily":2,"textAlign":"center","verticalAlign":"middle","id":"3a851aaab81fb6d1917d250604fcf158","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudFront Distribution-CloudFront Logs-forward-Access logs","x":562.6136703491211,"y":429,"text":"Access logs","type":"textbox","width":63.125,"height":16,"angle":0,"groupIds":["ee563396b4e848ff230125628e93dc45"],"lockedGroupId":"ee563396b4e848ff230125628e93dc45","seed":1761292911,"version":3,"versionNonce":1055376623,"isDeleted":false,"boundElementIds":null,"mode":"normal","hasFixedBounds":true,"modifiedAt":1757001476560,"figureId":null,"zIndex":21},{"id":"492aded270bf2cbcf0d93f061df30104","containerId":"3ebb2d8b4eee76f455645bf00fdd652e","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"CloudTrail","diagramRole":"node","strokeColor":"#242424","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"name":"aws-cloudtrail","customStyle":true,"x":975.9943084716797,"y":202,"compound":{"type":"parent","containerType":"cad-node","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"CloudTrail","icon":{"name":"aws-cloudtrail"}}},"type":"icon","width":50,"height":50,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":1119834625,"version":3,"versionNonce":367911919,"isDeleted":false,"boundElementIds":["d883fc4eab479749f846d613c1c30038","3a1d7de355ce4fe0afe9c44a74bfc81a"],"modifiedAt":1757001476560,"figureId":null,"zIndex":22},{"id":"d883fc4eab479749f846d613c1c30038","type":"arrow","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-S3 Bucket-CloudTrail-forward-Object, versioning","strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"elbow","roughness":0,"opacity":100,"arrowHeadSize":12,"shouldApplyRoughness":true,"startArrowhead":null,"endArrowhead":"arrow","cardinalElbowData":{"isEnabled":true},"points":[[0,0],[33,0],[33,15],[197,15]],"x":778.5125350952148,"y":212.33333333333334,"diagramCodeElement":{"from":"S3 Bucket","to":"CloudTrail","relationshipType":"FORWARD","label":"Object, versioning"},"lastCommittedPoint":null,"startBinding":{"elementId":"f958c69f8edd53ca27b7d03f7afb9074","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[1,0.3333333333333337],"direction":"right"}},"endBinding":{"elementId":"492aded270bf2cbcf0d93f061df30104","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[-1.0192709350585938,0.013333333333333712],"direction":"left"}},"width":197,"height":15,"angle":0,"groupIds":["559f03968254a6541a4ebb761f82dff8"],"lockedGroupId":"559f03968254a6541a4ebb761f82dff8","seed":21241153,"version":2,"versionNonce":1948868193,"isDeleted":false,"boundElementIds":null,"textGap":[57.73225402832031,5.166666666666657,96.40625,18],"modifiedAt":1757001476560,"figureId":null,"zIndex":23},{"strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"scale":1,"fontSize":13,"parentElementMetadata":{"elementId":"d883fc4eab479749f846d613c1c30038","type":"arrow"},"fontFamily":2,"textAlign":"center","verticalAlign":"middle","id":"7fb43eacbd80b4c3c087f61948688dc9","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-S3 Bucket-CloudTrail-forward-Object, versioning","x":837.2447891235352,"y":218.5,"text":"Object, versioning","type":"textbox","width":94.40625,"height":16,"angle":0,"groupIds":["559f03968254a6541a4ebb761f82dff8"],"lockedGroupId":"559f03968254a6541a4ebb761f82dff8","seed":981996367,"version":3,"versionNonce":1147860015,"isDeleted":false,"boundElementIds":null,"mode":"normal","hasFixedBounds":true,"modifiedAt":1757001476560,"figureId":null,"zIndex":24},{"id":"4e85625e3757f756b4aae36c75323f8f","containerId":"3ebb2d8b4eee76f455645bf00fdd652e","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"Billing Alarm","diagramRole":"node","strokeColor":"#242424","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":1,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"name":"aws-cloudwatch","customStyle":true,"x":1173.4761123657227,"y":202,"compound":{"type":"parent","containerType":"cad-node","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"Billing Alarm","icon":{"name":"aws-cloudwatch"}}},"type":"icon","width":50,"height":50,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":805406145,"version":3,"versionNonce":1933956737,"isDeleted":false,"boundElementIds":["3a1d7de355ce4fe0afe9c44a74bfc81a"],"modifiedAt":1757001476560,"figureId":null,"zIndex":25},{"id":"3a1d7de355ce4fe0afe9c44a74bfc81a","type":"arrow","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudTrail-Billing Alarm-forward-Audit logs","strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"elbow","roughness":0,"opacity":100,"arrowHeadSize":12,"shouldApplyRoughness":true,"startArrowhead":null,"endArrowhead":"arrow","cardinalElbowData":{"isEnabled":true},"points":[[0,0],[147,0]],"x":1025.9943084716797,"y":227,"diagramCodeElement":{"from":"CloudTrail","to":"Billing Alarm","relationshipType":"FORWARD","label":"Audit logs"},"lastCommittedPoint":null,"startBinding":{"elementId":"492aded270bf2cbcf0d93f061df30104","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[1,0],"direction":"right"}},"endBinding":{"elementId":"4e85625e3757f756b4aae36c75323f8f","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[-1.0192721557617188,0],"direction":"left"}},"width":147,"height":0,"angle":0,"groupIds":["26d10014883ca744c5c6451832cb298e"],"lockedGroupId":"26d10014883ca744c5c6451832cb298e","seed":1374081391,"version":2,"versionNonce":1125182017,"isDeleted":false,"boundElementIds":null,"textGap":[43.34491729736328,-9.5,53.75,18],"modifiedAt":1757001476560,"figureId":null,"zIndex":26},{"strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"scale":1,"fontSize":13,"parentElementMetadata":{"elementId":"3a1d7de355ce4fe0afe9c44a74bfc81a","type":"arrow"},"fontFamily":2,"textAlign":"center","verticalAlign":"middle","id":"36834e963e4566b2e330610c6ea34ecc","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudTrail-Billing Alarm-forward-Audit logs","x":1070.339225769043,"y":218.5,"text":"Audit logs","type":"textbox","width":51.75,"height":16,"angle":0,"groupIds":["26d10014883ca744c5c6451832cb298e"],"lockedGroupId":"26d10014883ca744c5c6451832cb298e","seed":1102872833,"version":3,"versionNonce":1652201039,"isDeleted":false,"boundElementIds":null,"mode":"normal","hasFixedBounds":true,"modifiedAt":1757001476560,"figureId":null,"zIndex":27},{"id":"6fb9171a03189a23e86fac9b752f1ce5","strokeColor":"#c38424","backgroundColor":"rgba(253,251,246, 1)","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"round","roughness":0,"opacity":100,"elementStyle":1,"colorMode":0,"diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"CI","type":"rectangle","isContainer":true,"diagramRole":"group","sizingMode":"auto","compound":{"type":"parent","containerType":"group","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"CI","icon":{"name":"github"}}},"x":1459.5199432373047,"y":266,"width":100,"height":163,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":1475183713,"version":2,"versionNonce":987884321,"isDeleted":false,"boundElementIds":null,"modifiedAt":1757001476559,"figureId":null,"zIndex":28},{"id":"b03b9de2691ebdde3a076525728866cd","containerId":"6fb9171a03189a23e86fac9b752f1ce5","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"GitHub Actions","diagramRole":"node","strokeColor":"#242424","backgroundColor":"#242424","fillStyle":"solid","strokeWidth":0.1,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"name":"github","customStyle":false,"x":1479.5199432373047,"y":316,"compound":{"type":"parent","containerType":"cad-node","settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"children":{"label":"GitHub Actions","icon":{"name":"github"}}},"type":"icon","width":50,"height":50,"angle":0,"groupIds":[],"lockedGroupId":null,"seed":1436141953,"version":3,"versionNonce":763989519,"isDeleted":false,"boundElementIds":["8efabbed6de7b950a5f007dbdc37faca","6a5e3bfdcf928fae50bb16c29aa7b95d","84071f7ff04ba7228388a8dca224e301"],"modifiedAt":1757001476560,"figureId":null,"zIndex":29},{"id":"8efabbed6de7b950a5f007dbdc37faca","type":"arrow","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-IAM CI Deployer-GitHub Actions-forward-AssumeRole","strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"elbow","roughness":0,"opacity":100,"arrowHeadSize":12,"shouldApplyRoughness":true,"startArrowhead":null,"endArrowhead":"arrow","cardinalElbowData":{"isEnabled":true},"points":[[0,0],[66,0],[66,-32],[191,-32],[191,0],[256,0]],"x":1223.4761123657227,"y":341,"diagramCodeElement":{"from":"IAM CI Deployer","to":"GitHub Actions","relationshipType":"FORWARD","label":"AssumeRole"},"lastCommittedPoint":null,"startBinding":{"elementId":"860266f3a0faf048a7995bbf1ee3e8c6","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[1,0],"direction":"right"}},"endBinding":{"elementId":"b03b9de2691ebdde3a076525728866cd","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[-1.0017532348632812,0],"direction":"left"}},"width":256,"height":32,"angle":0,"groupIds":["d29ff5ba94a0b3c46632b319737c4fc9"],"lockedGroupId":"d29ff5ba94a0b3c46632b319737c4fc9","seed":564965935,"version":2,"versionNonce":960315841,"isDeleted":false,"boundElementIds":null,"textGap":[93.99913787841797,-42,68.9375,18],"modifiedAt":1757001476560,"figureId":null,"zIndex":30},{"strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"scale":1,"fontSize":13,"parentElementMetadata":{"elementId":"8efabbed6de7b950a5f007dbdc37faca","type":"arrow"},"fontFamily":2,"textAlign":"center","verticalAlign":"middle","id":"c75a9c220cfcd1a4b45fbfec26ef3f90","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-IAM CI Deployer-GitHub Actions-forward-AssumeRole","x":1318.4752502441406,"y":300,"text":"AssumeRole","type":"textbox","width":66.9375,"height":16,"angle":0,"groupIds":["d29ff5ba94a0b3c46632b319737c4fc9"],"lockedGroupId":"d29ff5ba94a0b3c46632b319737c4fc9","seed":575802433,"version":3,"versionNonce":1971418831,"isDeleted":false,"boundElementIds":null,"mode":"normal","hasFixedBounds":true,"modifiedAt":1757001476560,"figureId":null,"zIndex":31},{"id":"6a5e3bfdcf928fae50bb16c29aa7b95d","type":"arrow","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-S3 Bucket-GitHub Actions-backward-aws s3 sync + invalidation","strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"elbow","roughness":0,"opacity":100,"arrowHeadSize":12,"shouldApplyRoughness":true,"startArrowhead":"arrow","endArrowhead":null,"cardinalElbowData":{"isEnabled":true},"points":[[0,0],[33,0],[33,-15],[511,-15],[511,5],[646,5],[646,133],[701,133]],"x":778.5125350952148,"y":195.66666666666666,"diagramCodeElement":{"from":"S3 Bucket","to":"GitHub Actions","relationshipType":"BACKWARD","label":"aws s3 sync + invalidation"},"lastCommittedPoint":null,"startBinding":{"elementId":"f958c69f8edd53ca27b7d03f7afb9074","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[1,-0.3333333333333337],"direction":"right"}},"endBinding":{"elementId":"b03b9de2691ebdde3a076525728866cd","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[-1.0002963256835937,-0.49333333333333484],"direction":"left"}},"width":701,"height":148,"angle":0,"groupIds":["2f35711e97ebc6b6e540407b0981562d"],"lockedGroupId":"2f35711e97ebc6b6e540407b0981562d","seed":98395073,"version":2,"versionNonce":2030841185,"isDeleted":false,"boundElementIds":null,"textGap":[532.3611526489258,-11.416666666666657,82.140625,31],"modifiedAt":1757001476560,"figureId":null,"zIndex":32},{"strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"scale":1,"fontSize":13,"parentElementMetadata":{"elementId":"6a5e3bfdcf928fae50bb16c29aa7b95d","type":"arrow"},"fontFamily":2,"textAlign":"center","verticalAlign":"middle","id":"b5df66bde23dc31d5357757a16dde5a4","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-S3 Bucket-GitHub Actions-backward-aws s3 sync + invalidation","x":1311.8736877441406,"y":185.25,"text":"aws s3 sync + invalidation","type":"textbox","width":80.140625,"height":29,"angle":0,"groupIds":["2f35711e97ebc6b6e540407b0981562d"],"lockedGroupId":"2f35711e97ebc6b6e540407b0981562d","seed":1542223055,"version":3,"versionNonce":253793583,"isDeleted":false,"boundElementIds":null,"mode":"normal","hasFixedBounds":true,"modifiedAt":1757001476560,"figureId":null,"zIndex":33},{"id":"84071f7ff04ba7228388a8dca224e301","type":"arrow","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudFront Distribution-GitHub Actions-backward-CreateInvalidation","strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"elbow","roughness":0,"opacity":100,"arrowHeadSize":12,"shouldApplyRoughness":true,"startArrowhead":"arrow","endArrowhead":null,"cardinalElbowData":{"isEnabled":true},"points":[[0,0],[32,0],[112,0],[112,248],[1023,248],[1023,-120],[1088,-120]],"x":391.36578369140625,"y":473.4166666666667,"diagramCodeElement":{"from":"CloudFront Distribution","to":"GitHub Actions","relationshipType":"BACKWARD","label":"CreateInvalidation"},"lastCommittedPoint":null,"startBinding":{"elementId":"1e415ed9a5ebf9b05c0f11142d3cfb3c","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[1,0.6666666666666674],"direction":"right"}},"endBinding":{"elementId":"b03b9de2691ebdde3a076525728866cd","bindingType":"portOrCenter","portLocationOptions":{"portLocation":"fixed.CustomPort","relativeOffset":[-1.0061663818359374,0.4966666666666674],"direction":"left"}},"width":1088,"height":368,"angle":0,"groupIds":["776e876d01a138b8e80c0dd168caae7f"],"lockedGroupId":"776e876d01a138b8e80c0dd168caae7f","seed":1531118319,"version":2,"versionNonce":1623316801,"isDeleted":false,"boundElementIds":null,"textGap":[537.8769073486328,235.25333333333327,96.15625,18],"modifiedAt":1757001476560,"figureId":null,"zIndex":34},{"strokeColor":"#000000","backgroundColor":"transparent","fillStyle":"solid","strokeWidth":0.75,"strokeStyle":"solid","strokeSharpness":"sharp","roughness":0,"opacity":100,"scale":1,"fontSize":13,"parentElementMetadata":{"elementId":"84071f7ff04ba7228388a8dca224e301","type":"arrow"},"fontFamily":2,"textAlign":"center","verticalAlign":"middle","id":"86afed67f16e98029a935f84056d6e06","diagramId":"c_nf9dW1EgwcRTnAE2kXW","diagramEntityId":"rel-CloudFront Distribution-GitHub Actions-backward-CreateInvalidation","x":930.2426910400391,"y":709.67,"text":"CreateInvalidation","type":"textbox","width":94.15625,"height":16,"angle":0,"groupIds":["776e876d01a138b8e80c0dd168caae7f"],"lockedGroupId":"776e876d01a138b8e80c0dd168caae7f","seed":815146881,"version":3,"versionNonce":1741952847,"isDeleted":false,"boundElementIds":null,"mode":"normal","hasFixedBounds":true,"modifiedAt":1757001476560,"figureId":null,"zIndex":35}],"diagramMetadata":{"settings":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","direction":"right"},"diagramType":"cloud-architecture-diagram","diagramId":"c_nf9dW1EgwcRTnAE2kXW","connections":[{"from":"Browser","to":"CloudFront Distribution","connectionType":">","label":"HTTPS request"},{"from":"CloudFront Distribution","to":"S3 Bucket","connectionType":">","label":"Origin fetch (OAI)"},{"from":"CloudFront Distribution","to":"ACM","connectionType":">","label":"Uses TLS cert"},{"from":"IAM CI Deployer","to":"GitHub Actions","connectionType":">","label":"AssumeRole"},{"from":"CloudFront Distribution","to":"CloudFront Logs","connectionType":">","label":"Access logs"},{"from":"S3 Bucket","to":"CloudTrail","connectionType":">","label":"Object, versioning"},{"from":"CloudTrail","to":"Billing Alarm","connectionType":">","label":"Audit logs"},{"from":"CloudFront Distribution","to":"Route 53","connectionType":"<","label":"Alias / A record"},{"from":"S3 Bucket","to":"GitHub Actions","connectionType":"<","label":"aws s3 sync + invalidation"},{"from":"CloudFront Distribution","to":"GitHub Actions","connectionType":"<","label":"CreateInvalidation"}],"entitySettings":{"Internet":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","icon":"globe"},"Browser":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","label":"User Browser","icon":"monitor"},"AWS Edge":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","icon":"aws-cloudfront"},"CloudFront Distribution":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","label":"CloudFront","icon":"aws-cloudfront"},"rel-Browser-CloudFront Distribution-forward-HTTPS request":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"AWS Region":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","icon":"aws"},"ACM":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","label":"ACM (TLS Cert)","icon":"aws-certificate-manager"},"rel-CloudFront Distribution-ACM-forward-Uses TLS cert":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"S3 Bucket":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","label":"S3 (static-site-bucket)","icon":"aws-s3"},"rel-CloudFront Distribution-S3 Bucket-forward-Origin fetch (OAI)":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"CloudFront OAI":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","label":"OAI / OAC","icon":"aws-cloudfront"},"Route 53":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","label":"Route 53","icon":"aws-route-53"},"rel-CloudFront Distribution-Route 53-backward-Alias / A record":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"IAM CI Deployer":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","label":"IAM: CI Deployer","icon":"aws-iam"},"CloudFront Logs":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","label":"CloudFront Logs","icon":"aws-cloudwatch"},"rel-CloudFront Distribution-CloudFront Logs-forward-Access logs":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"CloudTrail":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","icon":"aws-cloudtrail"},"rel-S3 Bucket-CloudTrail-forward-Object, versioning":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"Billing Alarm":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","label":"Billing Alarm","icon":"aws-cloudwatch"},"rel-CloudTrail-Billing Alarm-forward-Audit logs":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"CI":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","icon":"github"},"GitHub Actions":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough","icon":"github"},"rel-IAM CI Deployer-GitHub Actions-forward-AssumeRole":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"rel-S3 Bucket-GitHub Actions-backward-aws s3 sync + invalidation":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"},"rel-CloudFront Distribution-GitHub Actions-backward-CreateInvalidation":{"colorMode":"pastel","styleMode":"shadow","typeface":"rough"}}}}

**Notes:**

* The ACM certificate for CloudFront **must** be requested in `us-east-1` (N. Virginia). The Terraform example uses a provider alias for that region.
* The S3 bucket is private. CloudFront uses an Origin Access Identity (OAI) to fetch objects.

---

## What this repo contains

* `README.md` (this document)
* `terraform/` — Terraform project to provision S3, CloudFront, ACM (DNS validation with Route53 optional), IAM deployer policy, and sample objects.

  * `main.tf`, `variables.tf`, `outputs.tf`
* `site/` — example static site (index.html, assets)
* `.github/workflows/deploy.yml` — GitHub Actions CI to sync files to S3 and invalidate CloudFront cache
* `samples/` — sample IAM policy, sample bucket policy, sample curl/validation scripts
* `COST_ESTIMATE.md` — short monthly cost scenarios and calculation assumptions

---

## Quick architecture summary

1. S3 (private) stores the static site (index.html, assets, images). Bucket public access is blocked.
2. CloudFront Distribution in front of the bucket provides HTTPS, caching, compression, and geo-optimized delivery.
3. ACM (in `us-east-1`) issues the TLS certificate used by CloudFront.
4. Route53 (optional) maps `www.example.com` to the CloudFront distribution via alias record.
5. GitHub Actions (or other CI) performs `aws s3 sync` and issues a CloudFront invalidation on deploy.

---

## Reproducible Infrastructure (Terraform) — Example

> Files shown are condensed for readability. Full files are available in `terraform/`.

### `terraform/variables.tf`

```hcl
variable "region" {
  description = "Primary AWS region for S3 and resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Global-unique S3 bucket name for the site"
  type        = string
}

variable "domain_name" {
  description = "Optional custom domain name (eg www.example.com)"
  type        = string
  default     = ""
}

variable "create_route53_records" {
  type    = bool
  default = false
}
```

### `terraform/main.tf`

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# provider alias for us-east-1 because CloudFront/ACM cert must be in us-east-1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
  acl    = "private"
  force_destroy = true

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.site.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Origin Access Identity (classic OAI) to keep the bucket private
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI for static site bucket"
}

# Bucket policy to allow CloudFront OAI to GetObject
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.site.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCloudFrontServicePrincipalReadOnly",
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai.iam_arn
        },
        Action = ["s3:GetObject"],
        Resource = ["${aws_s3_bucket.site.arn}/*"]
      }
    ]
  })
}

# Request ACM certificate in us-east-1 (for CloudFront)
resource "aws_acm_certificate" "cert" {
  provider = aws.us_east_1
  domain_name = var.domain_name
  validation_method = var.create_route53_records ? "DNS" : "EMAIL"
  lifecycle {
    create_before_destroy = true
  }
}

# OPTIONAL: If Route53 is the DNS provider in your account, create DNS validation records
# (This block assumes the domain is hosted in Route53 in the same account)
resource "aws_route53_record" "cert_validation" {
  count = var.create_route53_records && var.domain_name != "" ? length(aws_acm_certificate.cert.domain_validation_options) : 0
  name    = aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_name
  zone_id = data.aws_route53_zone.selected.zone_id
  type    = aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_type
  records = [aws_acm_certificate.cert.domain_validation_options[count.index].resource_record_value]
  ttl     = 600
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider = aws.us_east_1
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = var.create_route53_records ? [for r in aws_route53_record.cert_validation : r.fqdn] : []
}

# CloudFront distribution
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id   = "S3-${aws_s3_bucket.site.id}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = var.domain_name != "" ? [var.domain_name] : []

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.site.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
    compress     = true
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.cert.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "static-site-cdn"
  }
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "s3_bucket" {
  value = aws_s3_bucket.site.bucket
}
```

### `terraform/outputs.tf`

```hcl
output "cloudfront_domain" {
  value = aws_cloudfront_distribution.cdn.domain_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.site.bucket
}
```

---

## Sample `site/` (example static files)

```
site/
  index.html
  404.html
  css/style.css
  images/logo.png
```

A tiny sample `index.html` is included in the repo — it helps validate the distribution. The Terraform includes `aws_s3_bucket_object` examples to upload these files, but for real sites you will likely use `aws s3 sync` from a CI job.

---

## IAM — minimal deployer policy (sample)

Use a dedicated CI IAM user or role with a policy scoped to these actions (principle of least privilege):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3Deploy",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    },
    {
      "Sid": "CloudFrontInvalidate",
      "Effect": "Allow",
      "Action": [
        "cloudfront:CreateInvalidation"
      ],
      "Resource": "*"
    }
  ]
}
```

**Note:** CloudFront invalidation requires the distribution ID; the policy permits any distribution for simplicity in many CI setups — narrow it if possible.

---

## CI/CD — GitHub Actions deploy example

Place this at `.github/workflows/deploy.yml`:

```yaml
name: Deploy Static Site
on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-region: us-east-1
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }} # or use access key / secret
          role-session-name: github-actions
      - name: Sync site to S3
        run: |
          aws s3 sync site/ s3://${{ secrets.S3_BUCKET }} --delete
      - name: Invalidate CloudFront
        run: |
          aws cloudfront create-invalidation --distribution-id ${{ secrets.CLOUDFRONT_ID }} --paths "/*"
```

---

## Testing & validation

1. After provisioning, note `cloudfront_domain` output (e.g. `d1234abcdef.cloudfront.net`).
2. If you configured DNS, wait for DNS to propagate.
3. Use curl to test:

```bash
curl -I https://d1234abcdef.cloudfront.net/
# expect HTTP/2 200 and TLS details
```

4. Test cache headers:

```bash
curl -I https://d1234abcdef.cloudfront.net/index.html
# Check `x-cache` header: Hit or Miss
```

5. Perform an invalidation to purge cache after updates:

```bash
aws cloudfront create-invalidation --distribution-id $DIST_ID --paths "/*"
```

---

## Demo screenshots / short video (how to create)

I cannot create screenshots from your environment here, but you can create a short demo locally or in CI:

### Quick screenshot using `curl` + `webkit2png` or `puppeteer`

* `npm install -g puppeteer`
* `node -e "(async()=>{const p=require('puppeteer');const b=await p.launch();const page=await b.newPage();await page.goto('https://d1234abcdef.cloudfront.net');await page.screenshot({path:'demo.png',fullPage:true});await b.close();})()"`

### Make a 10s demo video from screenshots with `ffmpeg`

```bash
# create a series of screenshots (demo-001.png..demo-100.png) and then:
ffmpeg -framerate 10 -i demo-%03d.png -c:v libx264 -pix_fmt yuv420p demo.mp4
```

### Or record a browser session with OBS Studio (GUI) or `ffmpeg` screen capture for headless servers.

---

## Cost estimation (example scenarios)

> **Assumptions:** US region pricing. Prices change frequently — see AWS pricing pages for latest numbers.

**Small site example (monthly):**

* Storage: 10 GB in S3 Standard -> \~10 \* \$0.023 = **\$0.23 / month**
* Traffic: 100,000 pageviews, avg page size 1 MB → \~100 GB egress through CloudFront → 100 \* \$0.085 = **\$8.50 / month**
* Requests: CloudFront first 10M HTTP(S) requests are in many accounts free; S3 GET request costs are negligible at this scale.

**Rough total:** **\~\$10 / month** (excluding domain registration and Route53 hosted zone costs)

**Notes & levers to reduce cost:**

* Good cache TTLs and high CloudFront cache hit ratio reduce origin costs (S3 request & data transfer).
* Use optimized images, compressed assets, and Brotli/gzip to cut bytes transferred.
* Route large downloads through CloudFront and enable compression and caching policies.

---

## Security considerations

* Keep S3 bucket **private** and use OAI to ensure only CloudFront can read objects.
* Block public ACLs via `aws_s3_bucket_public_access_block`.
* Use HTTPS (ACM certificate) and enforce TLSv1.2 minimum.
* Use IAM roles for CI rather than long-lived access keys.
* Turn on CloudTrail and CloudWatch billing alarms for cost control.

---

## Next steps & enhancements

* Add **Origin Shield** to reduce origin load for dynamic backends.
* Use **Lambda\@Edge** or **CloudFront Functions** for edge transforms (e.g. A/B testing, cookies, redirects).
* Add **image optimization** on the fly (e.g., using Lambda\@Edge with sharp or third-party services).
* Integrate with a real CI/CD pipeline (GitHub, GitLab, Bitbucket) and store artifacts.

---

## Files you can find in this repo

* `/terraform` — IaC for core infra
* `/site` — sample site
* `/.github/workflows/deploy.yml` — deploy pipeline
* `/samples` — IAM policies, bucket policy, validation scripts

---

## License

MIT — feel free to reuse and adapt this for your organization.

---
