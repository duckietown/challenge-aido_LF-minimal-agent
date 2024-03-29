#!/usr/bin/env python3

from dataclasses import dataclass
from typing import Tuple

import numpy as np

from aido_agents import get_rotation, jpg2rgb
from aido_schemas import (
    Context,
    DB20Commands,
    DB20Observations,
    EpisodeStart,
    GetCommands,
    JPGImage,
    PWMCommands,
)


@dataclass
class MinimalAgentConfig:
    pwm_left_interval: Tuple[float, float] = (0.25, 0.3)
    pwm_right_interval: Tuple[float, float] = (0.25, 0.3)


class MinimalAgent:
    config: MinimalAgentConfig = MinimalAgentConfig()

    def init(self, context: Context):
        context.info("init()")

    def on_received_seed(self, data: int):
        np.random.seed(data)

    def on_received_episode_start(self, context: Context, data: EpisodeStart):
        # This is called at the beginning of episode.
        context.info(f'Starting episode "{data.episode_name}".')

    def on_received_observations(self, context: Context, data: DB20Observations):
        # Get the JPG image
        camera: JPGImage = data.camera
        # Convert to numpy array
        _rgb = jpg2rgb(camera.jpg_data)

    def on_received_get_commands(self, context: Context, data: GetCommands):
        # compute random commands
        l, u = self.config.pwm_left_interval
        pwm_left = np.random.uniform(l, u)
        l, u = self.config.pwm_right_interval
        pwm_right = np.random.uniform(l, u)
        pwm_commands = PWMCommands(motor_left=pwm_left, motor_right=pwm_right)

        # Set LEDs to a testing pattern
        led_commands = get_rotation(data.at_time)

        # commands = PWM + LED
        commands = DB20Commands(pwm_commands, led_commands)
        # write them out
        context.write("commands", commands)

    def finish(self, context: Context):
        context.info("finish()")
