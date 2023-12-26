import 'package:flutter/material.dart';
import 'package:hadar_program/src/core/theming/text_styles.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CircularProgressGauge extends StatelessWidget {
  const CircularProgressGauge({
    super.key,
    required this.val,
  });

  final double val;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: 180,
        child: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF3D94D2),
              Color(0xFF24517A),
            ],
          ).createShader(Offset.zero & bounds.size),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(360)),
              border: Border.all(
                width: 4,
                color: Colors.black,
                style: BorderStyle.solid,
              ),
            ),
            child: SfRadialGauge(
              axes: [
                RadialAxis(
                  startAngle: 270,
                  endAngle: 270,
                  showLabels: false,
                  showTicks: false,
                  radiusFactor: 0.9,
                  axisLineStyle: const AxisLineStyle(
                    thickness: 0,
                    color: Colors.black,
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: val * 100,
                      width: 0.2,
                      sizeUnit: GaugeSizeUnit.factor,
                      enableAnimation: true,
                      animationDuration: 20,
                      animationType: AnimationType.linear,
                    ),
                  ],
                  annotations: [
                    GaugeAnnotation(
                      widget: Text(
                        '${(val * 100).toInt()}%',
                        style: TextStyles.s30w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
